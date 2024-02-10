<?php

namespace App\Services\Simplelivepos\Facades;

use App\Services\Simplelivepos\SimpleliveposService;
use Illuminate\Support\Facades\Facade;

class Simple extends Facade
{
    protected static function getFacadeAccessor()
    {
        return SimpleliveposService::class;
    }
}