<?php

namespace App\Services;

use GuzzleHttp\Client;

class VivaWalletService
{
    protected $client;
    protected $merchantId;
    protected $apiKey;
    protected $baseUrl;

    public function __construct()
    {
        $this->merchantId = env('VIVA_WALLET_MERCHANT_ID');
        $this->apiKey = env('VIVA_WALLET_API_KEY');
        $this->baseUrl = env('VIVA_WALLET_BASE_URL');
        $this->client = new Client([
            'base_uri' => $this->baseUrl,
            'auth' => [$this->merchantId, $this->apiKey],
        ]);
    }

    public function createPaymentOrder($amount, $customerEmail, $callbackUrl)
    {
        $response = $this->client->post('orders', [
            'json' => [
                'amount' => $amount * 100, // Сумма в центах
                'customerEmail' => $customerEmail,
                'callbackUrl' => $callbackUrl,
                'sourceCode' => 'Default',
            ],
        ]);

        return json_decode($response->getBody(), true);
    }
}
