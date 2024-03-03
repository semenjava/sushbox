<?php

namespace App\Services\Simplelivepos\Tasks;

use App\Models\Payment;

class ImportPaymetsTask
{
    private array $data;

    public function __construct(array $data) 
    {
        $this->data = $data;
		
		$this->init();
    }
	
	private function init() 
	{
		$this->categories = $this->data['parentCategory'] ?? null;
		//$this->menus = $this->data['parentCategory']['menuItems'] ?? null;
		//$this->items = $this->data['parentCategory']['items'] ?? null;
	}

    public function run()
	{
		foreach($this->data as $pay) {
			$payment = Payment::firstOrNew(
				['uid' =>  $pay['id']]
			);
			
			$payment->code = $pay['id'];
			$payment->name = $pay['name'];
			$payment->description = ''; // ??
			$payment->redirect = $pay['id']; // ??
			$payment->amount = 0; // ??
			$payment->update_at = $pay['updatedAt'];
			$payment->delete_at = !empty($pay['delete']) ? $pay['updatedAt'] : null;

			$payment->save();
		}
		
	}
}
