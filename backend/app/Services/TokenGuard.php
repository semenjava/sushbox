<?php

namespace App\Services;

use Illuminate\Contracts\Auth\Guard;
use Illuminate\Http\Request;
use Illuminate\Auth\TokenGuard as BaseTokenGuard;

class TokenGuard extends BaseTokenGuard
{
    public function __construct($provider, Request $request)
    {
        parent::__construct($provider, $request);
    }

    public function user()
    {
        if ($this->user !== null) {
            return $this->user;
        }

        $token = $this->getTokenForRequest();

        if (!empty($token)) {
            $this->user = $this->provider->retrieveByCredentials(['temporary_token' => $token]);
        }

        return $this->user;
    }

    public function getTokenForRequest()
    {
        $token = $this->request->query('token');

        if (empty($token)) {
            $token = $this->request->bearerToken();
        }

        return $token;
    }
}
