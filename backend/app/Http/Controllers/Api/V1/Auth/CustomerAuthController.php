<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\CentralLogics\Helpers;
use App\CentralLogics\SMS_module;
use App\Http\Controllers\Controller;
use App\Mail\EmailVerification;
use App\Model\BusinessSetting;
use App\Model\EmailVerifications;
use App\Model\PhoneVerification;
use App\User;
use Firebase\JWT\JWT;
use GuzzleHttp\Exception\GuzzleException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Http\JsonResponse;
use GuzzleHttp\Client;
use Illuminate\Support\Carbon;
use Carbon\CarbonInterval;
use App\Traits\SmsGateway;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class CustomerAuthController extends Controller
{
    public function __construct(
        private User $user,
        private BusinessSetting $business_setting,
        private PhoneVerification $phone_verification
    ){}


    /**
     * Регистрация нового пользователя
     * @param Request $request
     * @return JsonResponse
     */
    public function registration(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'f_name' => 'required',
            'l_name' => 'required',
            'email' => 'required|unique:users',
            'phone' => 'required|unique:users|min:5|max:20',
            'password' => 'required|min:6',
        ], [
            'f_name.required' => translate('The first name field is required.'),
            'l_name.required' => translate('The last name field is required.'),
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $user = $this->user->create([
            'f_name' => $request->f_name,
            'l_name' => $request->l_name,
            'phone' => $request->phone,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'is_active' => 1,
            'refer_code' => Str::random(10),
        ]);

        $token = JWT::encode(['id' => $user->id, 'exp' => now()->addHours(24)->timestamp], env('JWT_SECRET'), 'HS256');

        DB::table('users')->where('id', $user->id)->update(['temporary_token' => $token]);

        return response()->json(['message' => 'Successfully registered!', 'token' => $token, 'user' => ['name' => $user->f_name.' '.$user->l_name, 'phone' => $user->phone]], 200);
    }

    /**
     * Проверка телефона перед отправкой OTP
     * @param Request $request
     * @return JsonResponse
     */
    public function check_phone(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|min:5|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $otp = rand(1000, 9999);
        $this->phone_verification->create([
            'phone' => $request->phone,
            'token' => $otp,
            'created_at' => now(),
            'expires_at' => now()->addMinutes(10),
        ]);
        SMS_module::send($request->phone, $otp);

        return response()->json(['message' => 'OTP sent successfully!'], 200);
    }

    /**
     * Проверка email перед отправкой OTP
     * @param Request $request
     * @return JsonResponse
     */
    public function check_email(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $token = Str::random(120);
        DB::table('email_verifications')->insert([
            'email' => $request['email'],
            'token' => $token,
            'created_at' => now(),
            'expires_at' => now()->addMinutes(60),
        ]);
        $location = $request->header('X-localization') ?? 'en';
        Mail::to($request['email'])->send(new EmailVerification($token,$location));

        return response()->json(['message' => 'Email verification token sent successfully!'], 200);
    }

    /**
     * Подтверждение телефона с помощью OTP
     * @param Request $request
     * @return JsonResponse
     */
    public function verify_phone(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|min:5|max:20',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $verification = $this->phone_verification->where([
            'phone' => $request->phone,
            'token' => $request->otp,
        ])->first();

        if ($verification && $verification->expires_at > now()) {
            $this->user->where('phone', $request->phone)->update(['is_phone_verified' => 1]);
            $verification->delete();
            return response()->json(['message' => 'Phone number verified successfully!'], 200);
        }

        return response()->json(['errors' => [
            ['code' => 'otp', 'message' => translate('Invalid or expired OTP!')]
        ]], 403);
    }

    /**
     * Подтверждение email с помощью токена
     * @param Request $request
     * @return JsonResponse
     */
    public function verify_email(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'token' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $verification = DB::table('email_verifications')->where([
            'email' => $request->email,
            'token' => $request->token,
        ])->first();

        if ($verification && $verification->expires_at > now()) {
            $this->user->where('email', $request->email)->update(['is_email_verified' => 1]);
            DB::table('email_verifications')->where('email', $request->email)->delete();
            return response()->json(['message' => 'Email verified successfully!'], 200);
        }

        return response()->json(['errors' => [
            ['code' => 'token', 'message' => translate('Invalid or expired token!')]
        ]], 403);
    }

    /**
     * Авторизация пользователя
     * @param Request $request
     * @return JsonResponse
     */
    public function login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|min:5|max:20',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $user = $this->user->where('phone', $request->phone)->first();

        if ($user && Hash::check($request->password, $user->password)) {
            if ($user->is_active == 0) {
                return response()->json(['errors' => [
                    ['code' => 'auth-001', 'message' => translate('Account is inactive!')]
                ]], 403);
            }

            $token = JWT::encode(['id' => $user->id], env('JWT_SECRET'), 'HS256');

            DB::table('users')->where('id', $user->id)->update(['temporary_token' => $token]);

            return response()->json(['token' => $token, 'user' => ['name' => $user->f_name.' '.$user->l_name, 'phone' => $user->phone]], 200);
        }

        return response()->json(['errors' => [
            ['code' => 'auth-002', 'message' => translate('Invalid credentials!')]
        ]], 403);
    }

    /**
     * Социальная авторизация пользователя
     * @param Request $request
     * @return JsonResponse
     */
    public function social_customer_login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'provider' => 'required|in:google,facebook,apple',
            'access_token' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        // Пример использования клиента для запроса данных пользователя у провайдера
        $client = new Client();
        $response = $client->get('URL_PROVIDER', [
            'headers' => [
                'Authorization' => 'Bearer ' . $request->access_token,
            ],
        ]);

        $providerUser = json_decode($response->getBody(), true);

        $user = $this->user->firstOrCreate(
            ['email' => $providerUser['email']],
            [
                'f_name' => $providerUser['first_name'],
                'l_name' => $providerUser['last_name'],
                'is_active' => 1,
                'is_phone_verified' => 1,
                'is_email_verified' => 1,
            ]
        );

        $token = JWT::encode(['id' => $user->id], env('JWT_SECRET'), 'HS256');

        DB::table('users')->where('id', $user->id)->update(['temporary_token' => $token]);

        return response()->json(['token' => $token], 200);
    }

    /**
     * Удаление аккаунта пользователя
     * @param Request $request
     * @return JsonResponse
     */
    public function remove_account(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => Helpers::error_processor($validator)], 403);
        }

        $user = $this->user->where('email', $request->email)->first();

        if ($user) {
            $user->delete();
            return response()->json(['message' => 'Account removed successfully!'], 200);
        }

        return response()->json(['errors' => [
            ['code' => 'auth-003', 'message' => translate('Account not found!')]
        ]], 404);
    }
}
