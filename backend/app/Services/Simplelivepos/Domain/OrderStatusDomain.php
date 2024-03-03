<?php

namespace App\Services\Simplelivepos\Domain;

use App\Services\Simplelivepos\Contracts\ApiDomain;
use App\Services\Simplelivepos\Request\OrderStatusRequest;
use App\Services\Simplelivepos\Endpoint\OrderStatusEndpoint;

class OrderStatusDomain extends ApiDomain
{
	private $data;

    public function __construct()
    {
        $request = new OrderStatusRequest;
        $endpoint = new OrderStatusEndpoint($request);
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
		$request->setData($this->data);

        $transformer = $request->instaceTransformerInterfase();
+
        $data = $transformer->transform();

        return $data;

    }

	public function setData(array $data)
	{
		$this->data = $data;
	}
