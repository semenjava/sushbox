<?php

namespace App\Services\Simplelivepos\Endpoint;

use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Request\GetTokenRequest;
use TransformerInterfase;

class GetTokenEndpoint extends ApiEndpoint
{
    private $client;

    public function getMethod(): string
    {
        return 'POST';
    }

    public function getUrl(): string
    {
        $credential = $this->getCredential();
        return $credential->getBaseUrl(). '/Account/token';
    }
}
