<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\ImportItemsService;

class ImportItemsCategories extends Command
{
    /**
     * link inpirt products
     */
    private $link = 'https://sushi-box.gr/_next/data/UfWlMvB1wcdX1p9VzzNUj/el/online-order.json';

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:import-items';

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
        // $data = Simple::importItemsCategories();
        $service = new ImportItemsService($this->link);
        $service->init()->run();


    }
}
