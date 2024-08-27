<?php

namespace App\Console\Commands;

use App\CentralLogics\Helpers;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;
use App\Model\Order;
use Illuminate\Support\Facades\Http;

class UpdateStatusOrder extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'prepare:update_status_order';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $orders = Order::where('payment_status', Order::STATUS_UNPAID,)->where('payment_method', 'wallet_payment')->get();

        if($orders) {

            foreach ($orders as $order) {
                $order_code = str_replace('https://www.vivapayments.com/web/checkout?ref=', '', $order->callback);

                $client_id = config('app.paymets.merchant_id');
                $client_secret = config('app.paymets.api_key');
                $auth = base64_encode("$client_id:$client_secret");

                $response = Http::withHeaders([
                    'Authorization' => 'Basic ' . $auth,
                ])->get("https://www.vivapayments.com/api/orders/{$order_code}");

                $stateId = $response->json('StateId');

                /**
                 * The status of the order:

                    0 (Pending)
                    1 (Expired)
                    2 (Canceled)
                    3 (Paid)
                 */
                if($stateId == 3) {
                    $order->payment_status = Order::STATUS_PAID;
                    $order->save();
                }
            }
        }

        return 0;
    }

}
