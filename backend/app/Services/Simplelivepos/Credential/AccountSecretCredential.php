<?php

namespace App\Services\Simplelivepos\Credential;

use App\Services\Simplelivepos\Entities\Account;
use App\Services\Simplelivepos\Endpoint\GetTokenEndpoint;
use App\Models\Simplelivepos;
use Carbon\Carbon;
use App\Services\Simplelivepos\Domain\GetTokenDomain;

class AccountSecretCredential
{
    private $secret;
    private $simplelivepos;
    private $token;
    private $ip;
    private $companyId;

    public function __construct()
    {
        $this->secret = new Account();
        $this->simplelivepos = new Simplelivepos();
        $this->ip = request()->ip();
    }

    public function getAccount()
    {
        return $this->secret;
    }

    public function getApiUrl()
    {
        return config('simplelivepos.api_url');
    }

    public function instance()
    {
        list($companyId, $token, $data) = app(GetTokenDomain::class)->setCredential($this)->run() ?? config('simplelivepos.token');

        Simplelivepos::updateOrCreate(
            ['id' => $this->ip], 
            ['ip' => $this->ip, 'token' => $token, 'companyId' => $companyId, 'data' => $data] 
        );

        return [$companyId, $token];
    }

    public function getToken()
    {
        $simplelivepos = $this->simplelivepos->where('ip', $this->ip)->first();

        if(!$simplelivepos) {
            list($companyId, $token) = $this->instance();
            $this->token = $token;
            $this->companyId = $companyId;
        } else {
            $this->token = $simplelivepos->getToken();
            $this->companyId = $simplelivepos->getCompanyId();
        }

        return $this->token;
    } 

    public function getCompanyId() 
    {
        $simplelivepos = $this->simplelivepos->where('ip', $this->ip)->first();
        if(!$simplelivepos) {
            list($companyId, $token) = $this->instance();
            $this->token = $token;
            $this->companyId = $companyId;
        } else {
            $this->token = $simplelivepos->getToken();
            $this->companyId = $simplelivepos->getCompanyId();
        }

        return $this->companyId;
    }

}
