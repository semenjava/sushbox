<?php

namespace App\Services\Simplelivepos\Entities;

class Account
{
    private $login;
    private $password;

    public function __construct()
    {
        $this->login = config('simplelivepos.login');
        $this->password = config('simplelivepos.password');
    }
}
