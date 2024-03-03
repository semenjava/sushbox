<?php

namespace App\Services\Simplelivepos\Response;

use App\Services\Simplelivepos\Contracts\ApiResponce;

class ImportPaymetsResponce extends ApiResponce
{
    public function getResponse($response)
    {
        $data = $this->decodeResponse($response);
        return $data;
    }
}
