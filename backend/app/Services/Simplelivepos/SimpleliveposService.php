<?php

namespace App\Services\Simplelivepos;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use App\Services\Simplelivepos\Client\Connect;
use App\Services\Simplelivepos\Domain\{ImportItemsCategoriesDomain, ImportPaymetsDomain, OrderDomain, OrderStatusDomain};
use App\Services\Simplelivepos\Tasks\{ImportItemsCategoriesTask, ImportPaymetsTask, OrderStatusTask};

class SimpleliveposService
{
    private $credential;

    public function __construct() 
    {
        $this->init();
    }

    public function init()
    {
        $this->credential = app(Connect::class)->connect();
    }

    public function importItemsCategories()
    {
        $data = app(ImportItemsCategoriesDomain::class)->setCredential($this->credential)->run();
        //dd($data);

		$data = json_decode(config('test.importCategoryItems'), true);
		
		(new ImportItemsCategoriesTask($data))->run();
    }

	public function importPaymets()
    {
        $data = app(ImportPaymetsDomain::class)->setCredential($this->credential)->run();
		
		(new ImportPaymetsTask($data))->run();
    }

	public function order($order)
    {
        app(OrderDomain::class)->setCredential($this->credential)->setData($order)->run();
    }

	public function orderStatus($uids)
    {
		foreach ($uids as $uid) {
			$status = app(OrderStatusDomain::class)->setCredential($this->credential)->setData(['orderUId' => $uid])->run();

			(new OrderStatusTask($status))->run();
		}
	}
}
