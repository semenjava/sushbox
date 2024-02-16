<?php

namespace App\Services\Simplelivepos\Contracts;

abstract class ApiResponce implements ResponseInterface
{
    abstract public function getResponce(array $data);
}
