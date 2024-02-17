<?php

namespace App\Services\Simplelivepos\Contracts;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;

abstract class ApiEndpoint
{
    public ApiRequest $request;

    public function __construct(ApiRequest $request)
    {
        $this->request = $request;
    }

    public function getBaseUrl()
    {
        return config('simplelivepos.api_url');
    }

    abstract public function getMethod(): string;
    abstract public function getUrl(): string;

}
