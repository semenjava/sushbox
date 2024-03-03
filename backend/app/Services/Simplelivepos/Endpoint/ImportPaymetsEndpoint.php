<?php

namespace App\Services\Simplelivepos\Endpoint;

use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Request\GetTokenRequest;
use TransformerInterfase;

class ImportPaymetsEndpoint extends ApiEndpoint
{

    public function getMethod(): string
    {
        return 'GET';
    }

    public function getUrl(): string
    {
        return $this->getBaseUrl(). '/PayMethod';
    }
}
