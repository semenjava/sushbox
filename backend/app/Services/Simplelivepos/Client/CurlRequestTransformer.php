<?php

namespace App\Services\Simplelivepos\Client;

use anlutro\cURL\cURL;
use anlutro\cURL\Request;
use App\Services\Simplelivepos\Contracts\RequestInterface;
use App\Services\Simplelivepos\Contracts\ResponseInterface;
use App\Services\Simplelivepos\Contracts\ApiRequest;
use App\Services\Simplelivepos\Contracts\ApiResponce;

class CurlRequestTransformer
{
    private $transactionRequest;
    private $transactionResponse;

    public function __construct(ApiRequest $transactionRequest, ApiResponce $transactionResponce)
    {
        $this->transactionRequest = $transactionRequest;
        $this->transactionResponse = $transactionResponce;
    }

    /**
     * @param RequestInterface $transactionRequest
     * @return ResponseInterface
     */
    public function transform()
    {
        $endpoint = $this->transactionRequest->getEndpoint();
        $credential = $this->transactionRequest->getCredential();

        $api_token  = $credential->getToken();
        $companyId  = $credential->getCompanyId();

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
            ->setHeader('Cache-Control', 'no-cache,no-store')
            ->setHeader('Pragma', 'no-cache')
            ->setHeader('Expires', '-1')
            ->setHeader('Server', 'Microsoft-IIS/10.0')
            ->setHeader('X-Powered-By', 'ASP.NET');

        $response = $curl->sendRequest($request);
dd($response);
        return $this->transactionResponse->getResponse($response);
    }
}
