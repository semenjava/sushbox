<?php

namespace App\Services\Simplelivepos\Contracts;

interface RequestInterface
{
    public function instaceTransformerInterfase();
    public function getTransactionData(): array;
}
