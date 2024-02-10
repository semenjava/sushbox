<?php

return [
    'login' => env('SIMPLELIVEPOS_LOGIN', 'none'),
    'password' => env('SIMPLELIVEPOS_PASSWORD', 'none'),
    'api_url' => env('SIMPLELIVEPOS_URL', 'none'),
    'token' => null,
    'companyId' => null,

    'api' => [
        'getToket'=> '/Account/token'
    ]
];