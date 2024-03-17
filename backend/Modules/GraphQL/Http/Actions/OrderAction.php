<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\OrderTask;

class OrderAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $order = app(OrderTask::class)->setDto($this->dto)->run();
        return [
			'order_uid' => $order['order_uid']
			'status' => $order['status'],
			'mesage' => $order['mesage'] ?? '',
			'redirect_paymets' = $order['redirect_paymets'] ?? '',
		];
    }

}
