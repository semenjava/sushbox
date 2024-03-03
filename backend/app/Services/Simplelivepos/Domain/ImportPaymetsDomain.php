<?php

namespace App\Services\Simplelivepos\Domain;

use App\Services\Simplelivepos\Contracts\ApiDomain;
use App\Services\Simplelivepos\Request\ImportPaymetsRequest;
use App\Services\Simplelivepos\Endpoint\ImportPaymetsEndpoint;

class ImportPaymetsDomain extends ApiDomain
{
    public function __construct()
    {
        $request = new ImportPaymetsRequest;
        $endpoint = new ImportPaymetsEndpoint($request);
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
+
        $data = $transformer->transform();

        return $data;

    }
}
