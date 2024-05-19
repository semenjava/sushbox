<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Payment;

class PaymentsTask extends BaseTask
{
    public function run()
    {
        $payments = Payment::all();

        $data = [];
        foreach($payments as $payment) {
            $data[] = [
                'uid' => $payment->uuid,
                'name' => $payment->name,
                'price' => $payment->amount,
            ];
        }

        return $data;
    }
}