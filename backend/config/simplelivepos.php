<?php

return [
    'login' => env('SIMPLELIVEPOS_LOGIN', 'none'),
    'password' => env('SIMPLELIVEPOS_PASSWORD', 'none'),
    'api_url' => env('SIMPLELIVEPOS_URL', 'none'),
    'token' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoia2VzaWRpc2lna29yQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiYjBjOTFmMGItYzAyMS00MWNjLWZmOGMtMDhkYjBhNmNmZDAzIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoicm9sZU5hbWUiLCJleHAiOjE3MDg4MDc3MTMsImlzcyI6IlNpbXBsZUxpdmUiLCJhdWQiOiJTaW1wbGVMaXZlVXNlcnMifQ.scFfH9reDis1Q8rj9gnFyriP1tyYini_7Be2svhpfuY',
    'companyId' => null,

    'api' => [
        'getToket'=> '/Account/token'
    ]
];