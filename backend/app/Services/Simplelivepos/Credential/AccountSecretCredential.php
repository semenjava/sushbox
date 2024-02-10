<?php

namespace App\Services\Simplelivepos\Credential;

use App\Services\Simplelivepos\Entities\Account;

class AccountSecretCredential
{
    private $secret;

    public function __construct()
    {
        $this->secret = new Account();
    }

    public function getAccount()
    {
        return $this->secret;
    }

    public function getApiUrl()
    {
        return config('simplelivepos.api_url');
    }

}
