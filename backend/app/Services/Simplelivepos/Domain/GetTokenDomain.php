<?php

namespace App\Services\Simplelivepos\Domain;

use App\Services\Simplelivepos\Contracts\ApiDomain;
use App\Services\Simplelivepos\Request\GetTokenRequest;
use App\Services\Simplelivepos\Endpoint\GetTokenEndpoint;

class GetTokenDomain extends ApiDomain
{
    public function __construct(GetTokenRequest $request, GetTokenEndpoint $endpoint)
    {
        parent::__construct($request, $endpoint);
        
    }

    public function getRequest()
    {
        return $this->request;
    }

    public function run()
    {
        $credential = $this->getCredential();
        $request = $this->getRequest();
        $request->setCredential($credential);
        $request->setEndpoint($this->endpoint);

        $transformer = $request->instaceTransformerInterfase();

        $transformer->transform();

    }
}
