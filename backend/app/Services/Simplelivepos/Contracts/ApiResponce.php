<?php

namespace App\Services\Simplelivepos\Contracts;

abstract class ApiResponce implements ResponseInterface
{
    abstract public function getResponse($data);

    public function decodeResponse($response)
    {
        $data = json_decode($response->body, true) ?: null;

        if(!$data) {
            $uncompressedData = gzinflate(substr($response->body, 10, -8));
            $data = json_decode($uncompressedData, true);
            
        }

        return $data;
    }
}
