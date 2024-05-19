<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\PaymentsTask;

class PaymentsAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $cart = app(PaymentsTask::class)->setDto($this->dto)->run();

        return $cart;
    }

}
