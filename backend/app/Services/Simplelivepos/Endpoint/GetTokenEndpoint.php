<?php

namespace App\Services\Simplelivepos\Endpoint;

use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Request\GetTokenRequest;
use TransformerInterfase;

class GetTokenEndpoint extends ApiEndpoint
{
    private $client;

    public function __construct(GetTokenRequest $request)
    {
        parent::__construct($request);
        
    }

    public function getRequest(): string
    {
        return $this->request;
    }

    public function getMethod(): string
    {
        return 'POST';
    }

    public function getUrl(): string
    {
        $credential = $this->getCredential();
        return $credential->getBaseUrl(). '/Account/token';
    }

    public function run()
    {
        $credential = $this->getCredential();
        $request = $this->getRequest();
        $request->setCredential($credential);
        $request->setEndpoint($this);

        $transformer = $request->instaceTransformerInterfase();

        $transformer->transform();

    }
}
