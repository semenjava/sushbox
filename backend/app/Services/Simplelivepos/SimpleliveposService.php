<?php

namespace App\Services\Simplelivepos;

use App\Services\Simplelivepos\Credential\AccountSecretCredential;
use App\Services\Simplelivepos\Client\Connect;
use App\Services\Simplelivepos\Domain\ImportItemsCategoriesDomain;
use App\Services\Simplelivepos\Tasks\ImportItemsCategoriesTask;

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
}
