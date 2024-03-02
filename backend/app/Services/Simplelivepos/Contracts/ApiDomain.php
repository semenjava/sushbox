<?php

namespace App\Services\Simplelivepos\Contracts;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use App\Services\Simplelivepos\Contracts\ApiRequest;
use App\Services\Simplelivepos\Contracts\ApiEndpoint;

class ApiDomain
{
    public ApiRequest $request;
    public AccountSecretCredential $credential;
    public ApiEndpoint $endpoint;

    public function __construct(ApiRequest $request, ApiEndpoint $endpoint)
    {
        $this->request = $request;
        $this->endpoint = $endpoint;
    }

    public function setCredential(AccountSecretCredential $credential)
    {
        $this->credential = $credential;
        return $this;
    }

    public function getCredential()
    {
        return $this->credential;
    }
}
