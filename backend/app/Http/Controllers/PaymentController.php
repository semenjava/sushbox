<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\VivaWalletService;

class PaymentController extends Controller
{
    protected $vivaWalletService;

    public function __construct(VivaWalletService $vivaWalletService)
    {
        $this->vivaWalletService = $vivaWalletService;
    }

    public function createPayment(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric',
            'email' => 'required|email',
        ]);

        $amount = $request->input('amount');
        $email = $request->input('email');

        $callbackUrl = route('payment.callback');

        $paymentOrder = $this->vivaWalletService->createPaymentOrder($amount, $email, $callbackUrl);

        return redirect($paymentOrder['orderUrl']);
    }

    public function paymentCallback(Request $request)
    {
        // Здесь обрабатывайте callback от Viva Wallet
        // Проверьте статус платежа и обновите ваш заказ
        return response()->json(['status' => 'success']);
    }
}
