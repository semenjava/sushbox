<?php

namespace App\Services\Simplelivepos\Request;

use App\Services\Simplelivepos\Contracts\ApiRequest;
use App\Services\Simplelivepos\Contracts\ApiEndpoint;
use App\Services\Simplelivepos\Client\CurlRequestTransformer;
use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use App\Services\Simplelivepos\Response\OrderResponce;

class OrderRequest extends ApiRequest
{   
    private $credential;
    private $endpoint;
	private $data;

    public function instaceTransformerInterfase()
    {
        return new CurlRequestTransformer($this, new OrderResponce);
    }

    public function setCredential(AccountSecretCredential $credential): void
    {
        $this->credential = $credential;
    }

    public function getCredential(): AccountSecretCredential
    {
        return $this->credential;
    }

    public function setEndpoint(ApiEndpoint $endpoint): void
    {
        $this->endpoint = $endpoint;
    }

    public function getEndpoint(): ApiEndpoint
    {   
        return $this->endpoint;
    }

    public function getTransactionData(): ?array
    {
        return $this->data;
    }

	public function setData(array $data)
	{
		$this->data = $data;
	}

}