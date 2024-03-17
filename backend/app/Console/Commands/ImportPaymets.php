<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\Simplelivepos\Facades\Simple;

class ImportPaymets extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:import-paymets';

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
        $data = Simple::importPaymets();
    }
}
