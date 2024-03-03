<?php

namespace App\Services\Simplelivepos\Endpoint;

use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Request\GetTokenRequest;
use TransformerInterfase;

class OrderStatusEndpoint extends ApiEndpoint
{

    public function getMethod(): string
    {
        return 'POST';
    }

    public function getUrl(): string
    {
        return $this->getBaseUrl(). '/WebSite​/GetOrderStatus';
    }
}
