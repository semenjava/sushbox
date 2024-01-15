<?php

namespace Components\Modules\Tasks;

use Components\Properties\Property;

abstract class BaseTask
{
    private $dto;

    abstract public function run();

    /**
     * @param array $dto
     * @return $this
     */
    public function setDto (Property $dto = null)
    {
        $this->dto = $dto;
        return $this;
    }

    public function getDto(): Property
    {
        return $this->dto;
    }
}
