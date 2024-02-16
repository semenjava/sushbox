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

    public function __construct()
    {
        $this->secret = new Account();
        $this->simplelivepos = new Simplelivepos();
    }

    public function getAccount()
    {
        return $this->secret;
    }

    public function getApiUrl()
    {
        return config('simplelivepos.api_url');
    }

    public function getToken()
    {
        

        $ip = request()->ip();
        $this->token = $this->simplelivepos->where('ip', $ip)->where('created_at', '=', Carbon::now())->first();

        if(!$this->token) {
            $this->token = app(GetTokenDomain::class)->setCredential($this)->run();
            Simplelivepos::updateOrCreate(
                ['id' => $ip], 
                ['token' => $this->token] 
            );
        }

        return $this->token;
    } 

}
