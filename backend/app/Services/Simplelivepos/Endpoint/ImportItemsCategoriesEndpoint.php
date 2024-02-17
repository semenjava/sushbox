<?php

namespace App\Services\Simplelivepos\Endpoint;

use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Request\GetTokenRequest;
use TransformerInterfase;

class ImportItemsCategoriesEndpoint extends ApiEndpoint
{
    private $client;

    public function getMethod(): string
    {
        return 'GET';
    }

    public function getUrl(): string
    {
        return $this->getBaseUrl(). '/ItemCategories';
    }
}
