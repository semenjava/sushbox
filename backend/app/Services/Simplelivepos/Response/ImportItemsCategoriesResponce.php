<?php

namespace App\Services\Simplelivepos\Response;

use App\Services\Simplelivepos\Contracts\ApiResponce;

class ImportItemsCategoriesResponce extends ApiResponce
{
    public function getResponce(array $data)
    {
        dd($data);
        return $data;
    }
}
