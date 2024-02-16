<?php

namespace App\Services\Simplelivepos\Contracts;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;

abstract class ApiEndpoint
{
    public ApiRequest $request;
    public AccountSecretCredential $credential;

    public function __construct(ApiRequest $request)
    {
        $this->request = $request;
    }

    abstract public function getRequest();
    abstract public function run();

    abstract public function getMethod(): string;
    abstract public function getUrl(): string;

}
