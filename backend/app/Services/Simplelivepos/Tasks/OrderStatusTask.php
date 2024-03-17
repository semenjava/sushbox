<?php

namespace App\Services\Simplelivepos\Tasks;

use App\Models\Order;

class OrderStatusTask
{
    private array $data;

    public function __construct(array $data) 
    {
        $this->data = $data;
		
		$this->init();
    }
	
	private function init() 
	{
	}

    public function run()
	{
		$order = Order::where('uid', $this->data['uid']);
			
		$payment->status = $order['accepted'] ?? 'process';
		$payment->data = json_encode($this->data) ?? null;

		$payment->save();
		
	}
}
