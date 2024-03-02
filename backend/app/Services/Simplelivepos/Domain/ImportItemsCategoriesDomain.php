<?php

namespace App\Services\Simplelivepos\Domain;

use App\Services\Simplelivepos\Contracts\ApiDomain;
use App\Services\Simplelivepos\Request\ImportItemsCategoriesRequest;
use App\Services\Simplelivepos\Endpoint\ImportItemsCategoriesEndpoint;

class ImportItemsCategoriesDomain extends ApiDomain
{
    public function __construct()
    {
        $request = new ImportItemsCategoriesRequest;
        $endpoint = new ImportItemsCategoriesEndpoint($request);
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
