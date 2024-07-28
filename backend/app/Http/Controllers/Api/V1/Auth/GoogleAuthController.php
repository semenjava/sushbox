<?php
namespace App\Http\Controllers\Api\V1\Auth;

use Socialite;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;

class GoogleAuthController extends Controller
{
    public function redirectToGoogle()
    {
        return Socialite::driver('google')->redirect();
    }

    public function handleGoogleCallback()
    {
        $user = Socialite::driver('google')->user();

        $existingUser = User::where('email', $user->email)->first();

        if ($existingUser) {
            Auth::login($existingUser);
        } else {
            // Create a new user record
            $newUser = User::create([
                'name' => $user->name,
                'email' => $user->email,
                'password' => null, // Since it's social login, no password needed
            ]);

            Auth::login($newUser);
        }

        return redirect()->intended('/');
    }
}
