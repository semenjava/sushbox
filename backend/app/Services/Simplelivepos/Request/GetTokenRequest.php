<?php

namespace App\Services\Simplelivepos\Request;

use App\Services\Simplelivepos\Contracts\ApiRequest;
use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Client\CurlRequestTransformer;
use App\Services\Simplelivepos\Credential\AccountSecretCredential;

class GetTokenRequest extends ApiRequest
{   
    private $credential;
    private $endpoint;

    public function instaceTransformerInterfase()
    {
        return new CurlRequestTransformer($this);
    }


    public function setCredential(AccountSecretCredential $credential): void
    {
        $this->credential = $credential;
    }

    public function getCredential(): AccountSecretCredential
    {
        return $this->credential;
    }

    public function setEndpoint(ApiEndpoint $endpoint): void
    {
        $this->endpoint = $endpoint;
    }

    public function getEndpoint(): ApiEndpoint
    {   
        return $this->endpoint;
    }

    public function getTransactionData():array
    {
        $secret = $this->getCredential()->getAccount();

        return  [
            'login' => $secret->login,
            'password' => $secret->password,
        ];
    }
}