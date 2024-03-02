<?php

namespace App\Services\Simplelivepos\Client;

use anlutro\cURL\cURL;
use anlutro\cURL\Request;
use App\Services\Simplelivepos\Contracts\RequestInterface;
use App\Services\Simplelivepos\Contracts\ResponseInterface;
use App\Services\Simplelivepos\Contracts\ApiRequest;
use App\Services\Simplelivepos\Contracts\ApiResponce;
use anlutro\cURL\Response;

class CurlRequestTokenTransformer
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
        $api_token = $this->getToken();
        $companyId = $this->getCompany($api_token);
        $data = $this->login($api_token, $companyId);

        return [$companyId, $api_token, $data];
    }

    private function getToken()
    {
        $endpoint = $this->transactionRequest->getEndpoint();
        $credential = $this->transactionRequest->getCredential();

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
            ->setOption(CURLOPT_SSL_VERIFYPEER, env('STAGE') === 'prod');

        $response = $curl->sendRequest($request);

        $token = $this->transactionResponse->getResponseToken($response);

        return $token;
    }

    private function getCompany($token)
    {
        $endpoint = $this->transactionRequest->getEndpoint();
        $credential = $this->transactionRequest->getCredential();

        $curl = new cURL();

        $request = $curl->newRequest(
            $endpoint->getMethodCompany(),
            $endpoint->getCompanyUrl(),
            [],
            Request::ENCODING_JSON
            )->setHeader('Content-Type', 'application/json')
            ->setHeader('Accept', '*/*')
            ->setHeader('Accept-Encoding', 'gzip, deflate, br')
            ->setHeader('Connection', 'keep-alive')
            ->setHeader('Authorization', 'Bearer ' . $token);

        $response = $curl->sendRequest($request);

        $companyId = $this->transactionResponse->getResponseCompany($response);

        return $companyId;
    }

    public function login($token, $companyId)
    {
        $endpoint = $this->transactionRequest->getEndpoint();
        $credential = $this->transactionRequest->getCredential();

        $curl = new cURL();

        $request = $curl->newRequest(
            $endpoint->getMethodLogin(),
            $endpoint->getLoginUrl($companyId),
            [],
            Request::ENCODING_JSON
            )->setHeader('Content-Type', 'application/json')
            ->setHeader('Accept', '*/*')
            ->setHeader('Accept-Encoding', 'gzip, deflate, br')
            ->setHeader('Connection', 'keep-alive')
            ->setHeader('Authorization', 'Bearer ' . $token);

        $response = $curl->sendRequest($request);

        $data = $this->transactionResponse->getResponse($response);

        return json_encode($data);
    }
}
