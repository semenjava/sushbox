<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\CartTask;

class CartAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $cart = app(CartTask::class)->setDto($this->dto)->run();

        return $cart;
    }

}
