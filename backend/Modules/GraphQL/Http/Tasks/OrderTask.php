<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Customer;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Hash;
use App\Models\Order;
use App\Models\OrderItems;
use App\Models\Items;
use App\Models\Payment;
use App\Services\Simplelivepos\Facades\Simple;
use App\Services\Simplelivepos\Presenter\OrderPresenter;
use App\Services\VivaWalletService;

class OrderTask extends BaseTask
{

    protected $vivaWalletService;

    public function __construct(VivaWalletService $vivaWalletService)
    {
        $this->vivaWalletService = $vivaWalletService;
    }

    public function run()
    {
	$json = $this->getDto()->get('data');
	$dataArray = json_decode($json, true);
	$dataOrder = $dataArray;

	$customer = $dataArray['customer']['customerDetails'];

	$email = $customer['email'];

	$user = Customer::where('email', $customer['email'])->first();
	if(!$user) {
		do {
			$uid = Str::uuid();
			$customer['uid'] = Str::uuid();
			$user = Customer::where('uid', $uid)->first();
		}
		while (!$user);
		
		$data['uid'] = $customer['uid'];
		$data['name'] = $customer['name'];
		$data['first_name'] = $customer['afm'] ?? '';
		$data['last_name'] = $customer['doy'] ?? '';
		$data['username'] = $customer['name'];
		$data['email'] = $customer['email'];
		$data['mobile'] = $customer['tel'];
		$data['password'] = Hash::make($customer['password']);
		$data = Arr::add($data, 'email_verified_at', Carbon::now());

		$user->fild($data);
		$user->save();
	}

	uset($dataOrder['password']);

	do {
		$order_uid = Str::uuid();
		$order = Order::where('uid', $order_uid)->first();
	}
	while (!$order);

	$status = 'create';
	$order_data['uid'] = $dataOrder['uid'] = $order_uid;
	$order_data['message_owner_id'] = $dataOrder['messageOwnerId'] = $customer['uid'];
	$order_data['items_count'] = count($dataArray['orderItems']);
	$order_data['delivery_price'] = $dataArray['deliveryPrice'];
	$order_data['status'] = $status;

	$order = Order::create($order_data);

	foreach ($data['orderItems'] as $item) {
		$uidsItems[] = $item['uId'];
	}

	//$payment = Payment::where('uid', $dataArray['paymentUId'])->first();

	$items = Items::whereIn('uid', $uidsItems)->pluck('uid');

	$item_order = [];
	$prices = [];
	$full_price = 0;
	foreach ($data['orderItems'] as $value) {
		$item = $items[$value['uId']];

		$dataOrder['productCode'] = $item->code;

		$item_order[] = [
			'order_uid' => $order_uid,
			'item_uid' => $value['uId'],
			'code' => $item->code,
			'bar_code' => $item->bar_code,
			'name' => $item->name,
			'quantity' => $value['quantity'],
			'price' => $value['price'],
			'discount' => $value['discount'],
		];
		$prices[] = $value['price'] - $value['discount'];
		
		OrderItems::create($item_order);
	}

	$full_price = sum($prices) + $order_data['delivery_price'];

	$order->price = sum($prices);
	$order->full_price = $full_price;
	$order->status = $status;
	$order->payment_uid = $dataArray['paymentUId'];

	$order->save();

	$orderData = (new OrderPresenter($dataOrder))->run();
	Simple::order($orderData);


	$callbackUrl = route('payment.frontend.callback');

	$paymentOrder = $this->vivaWalletService->createPaymentOrder($full_price, $email, $callbackUrl);

        return [
			'status' => $status,
			'mesage' => 'Order successfully',
			'redirect_paymets' => $paymentOrder['orderUrl'],
			'order_uid' => $order_uid
		];
    }
}