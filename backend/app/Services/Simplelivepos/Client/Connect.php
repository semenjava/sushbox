<?php

namespace App\Services\Simplelivepos\Client;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Http;

class Connect
{
    private $account;
    private $credential;
    private $apiUrl;
    private $token;
    private $companyId;

    public function __construct() 
    {
        $this->credential = new AccountSecretCredential();
        $this->init();
    }

    public function init()
    {
        $this->account = $this->credential->getAccount();
        $this->apiUrl = $this->credential->getApiUrl();
        $this->token = $this->credential->getToken();
        $this->companyId = $this->credential->getCompanyId();
    }

    public function connect(): AccountSecretCredential
    {
        return $this->credential;
    }
}
