<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\Simplelivepos\Facades\Simple;
use App\Models\Order;

class OrderStatus extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:order-status';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {
		$orders = Order::whereIn('status', ['process', 'create'])->get();

		$uids = [];
		foreach ($orders as $order) {
			$uids[] = $order->uid;
		}	

        Simple::orderStatus($uids);
    }
}
