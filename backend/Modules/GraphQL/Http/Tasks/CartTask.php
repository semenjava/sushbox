<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Order as Cart;

class CartTask extends BaseTask
{
    public function run()
    {
        $order_uuid = $this->getDto()->get('order_uuid');
        

        return Cart::where('uid', $order_uuid)->where('status', Cart::STATUS_IN_PROCESS)->first();
    }
}