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

    public function __construct() 
    {
        $this->credential = new AccountSecretCredential();
        $this->init();
    }

    public function init()
    {
        $this->account = $this->credential->getAccount();
        $this->apiUrl = $this->credential->getApiUrl();
    }

    public function connect(): AccountSecretCredential
    {
        return $this->credential;
    }
}
