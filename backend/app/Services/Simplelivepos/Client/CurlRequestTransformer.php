<?php

namespace App\Services\Simplelivepos\Client;

use anlutro\cURL\cURL;
use anlutro\cURL\Request;
use App\Services\Simplelivepos\Contracts\RequestInterface;
use App\Services\Simplelivepos\Contracts\ResponseInterface;
use App\Services\Simplelivepos\Contracts\ApiRequest;

class CurlRequestTransformer
{
    private $transactionRequest;

    public function __construct(ApiRequest $transactionRequest)
    {
        $this->transactionRequest = $transactionRequest;
    }

    /**
     * @param RequestInterface $transactionRequest
     * @return ResponseInterface
     */
    public function transform()
    {
        $endpoint = $this->transactionRequest->getEndpoint();

        $data = $this->transactionRequest->getTransactionData();

        $curl = new cURL();

        $request = $curl->newRequest(
            $endpoint->getMethod(),
            $endpoint->getUrl(),
            $data,
            Request::ENCODING_JSON
            )->setHeader('Content-Type', 'application/json')
            ->setHeader('Accept', '*/*')
            ->setHeader('Accept-Encoding', 'gzip, deflate, br')
            ->setHeader('Connection', 'keep-alive')
            ->setHeader('Authorization', 'Bearer ' . $api_token)
            ->setOption(CURLOPT_SSL_VERIFYPEER, env('STAGE') === 'prod');

        $response = $curl->sendRequest($request);

        return $transactionRequest->getResponse(\json_decode($response->body, true) ?: array());
    }
}
