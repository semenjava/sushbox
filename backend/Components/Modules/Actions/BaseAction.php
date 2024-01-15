<?php

namespace Components\Modules\Actions;

use App\Http\Controllers\Controller;
use Components\Properties\Property;

abstract class BaseAction extends Controller
{
    abstract public function run();

    protected $dto;
    protected $task;
    protected $data;
    protected $subAction;

    public function setDto (array $dto = [])
    {
        $this->dto = new Property($dto);
        return $this;
    }
}
