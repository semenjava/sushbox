<?php

namespace App\Services\Simplelivepos;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use App\Services\Simplelivepos\Client\Connect;

class SimpleliveposService
{

    public function __construct() 
    {
        $this->init();
    }

    public function init()
    {
        $credential = app(Connect::class)->connect();
    }

    public function send()
    {
        
    }
}
