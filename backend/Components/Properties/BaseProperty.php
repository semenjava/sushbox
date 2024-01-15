<?php

namespace Components\Properties;

abstract class BaseProperty
{
    abstract public function setProperty($key, $value);
    abstract public function getProperty($key=null);

    public function setInstaceProperty($propertis)
    {
        foreach ($propertis as $key => $value) {
            $this->setProperty($key, $value);
        }
    }
}
