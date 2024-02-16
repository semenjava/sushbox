<?php

namespace App\Services\Simplelivepos\Contracts;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use App\Services\Simplelivepos\Contracts\ApiEndpoint;

abstract class ApiRequest implements RequestInterface
{
    abstract public function setCredential(AccountSecretCredential $credential):void;
    abstract public function getCredential(): AccountSecretCredential;

    abstract public function setEndpoint(ApiEndpoint $endpoint):void;
    abstract public function getEndpoint(): ApiEndpoint;
}
