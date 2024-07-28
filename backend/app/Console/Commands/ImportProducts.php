<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportProducts extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'products:import';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {

        $products = DB::connection('mysql')->table('products')->get();
        foreach ($products as $item) {
            $data = [
                'product_id' => $item->id,
                'price' => $item->price,
                'discount_type' => 'percent',
                'discount' => $item->discount,
                'branch_id' => 1,
                'is_available' => 1,
                'variations' => '[]',
                'created_at' => now(),
                'updated_at' => now(),
                'stock_type' => 'unlimited',
                'stock' => 0,
                'sold_quantity' => 0
            ];

            DB::connection('mysql')->table('product_by_branches')->insert($data);
        }


        return Command::SUCCESS;
    }
}
