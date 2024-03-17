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
        return $this->getBaseUrl(). '/Account/token';
    }

    public function getMethodCompany(): string
    {
        return 'GET';
    }

    public function getCompanyUrl(): string
    {
        return $this->getBaseUrl(). '/Account/userCompanies';
    }

    public function getMethodLogin(): string
    {
        return 'GET';
    }

    public function getLoginUrl($companyId): string
    {
        return $this->getBaseUrl(). '/Account/loginWithCompany/'.$companyId;
    }
}
