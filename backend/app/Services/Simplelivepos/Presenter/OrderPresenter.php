<?php

namespace App\Services\Simplelivepos\Presenter;

use Carbon\Carbon;

class OrderPresenter
{
    private array $data;
	private $order;

    public function __construct(array $data) 
    {
        $this->data = $data;
    }

    public function init()
    {
		$customer = $this->data['customer']['customerDetails'];
		$order = $data['orderItems'];
		$paymentUId = $this->data['paymentUId'];

        $this->order = [
			  "uid" => $this->data['uid'],
			  "messageOwnerId" => $this->data['messageOwnerId'],
			  "timePlaced" => Carbon::now()->format('Y-m-d\TH:i:s.u\Z');,
			  "tableCode" => "",
			  "customComment" => $this->data['customComment'],
			  "pricebookUid" => "",
			  "customer" => [
				"customerDetails" => [
				  "uid" => $this->data['messageOwnerId'],
				  "name" => $customer['name'],
				  "afm" => $customer['afm'],
				  "doy" => $customer['doy'],
				  "tel" => $customer['tel'],
				  "comments" => "",
				  "loyaltyCard" => "",
				  "loyaltUid" => "",
				  "email" => $customer['email'],
				  "allowNotifications" => true
				],
				"location" => [
				  "uid" => "",
				  "address" => "string",
				  "city" => "string",
				  "postalCode" => "string",
				  "customerId" => $this->data['messageOwnerId'],
				  "longitude" => 0,
				  "latitude" => 0,
				  "phoneNumber" => $customer['tel'],
				  "bell" => "string",
				  "floor" => "string"
				]
			  ],
			  "orderItems" => [],
			  "estimatedTime" => 0
			];

			foreach ($data['orderItems'] as $item) {
				$this->order['orderItems'][] = [
					'uId' => $item['uId'],
					'price' => $item['price'],
					'quantity' => $item['quantity'],
					'customComment' => '',
					'productCode' => $item['productCode'],
					'discount' => $item['discount'],	
					'preferences' => [],
					'paymentUId' => $order['paymentUId']
				];
			}

			$this->order['estimatedTime'] = 0;
    }

    public function run()
    {
        return $this->order;
    }
}
