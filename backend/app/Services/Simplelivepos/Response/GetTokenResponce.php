<?php

namespace App\Services\Simplelivepos\Response;

use App\Services\Simplelivepos\Contracts\ApiResponce;

class GetTokenResponce extends ApiResponce
{
    public function getResponseToken($response)
    {
        $data = $this->decodeResponse($response);

        $token = !empty($data['token']) ? $data['token'] : null;

        return $token;
    }

    public function getResponseCompany($response)
    {
        $data = $this->decodeResponse($response);

        return !empty($data['availableCompanies'][0]['companyId']) ?$data['availableCompanies'][0]['companyId'] : null;
    }

    public function getResponse($response)
    {
        $data = $this->decodeResponse($response);
        return $data;
    }
}
