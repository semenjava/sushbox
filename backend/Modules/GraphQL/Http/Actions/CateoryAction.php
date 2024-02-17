<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\CategoriesTask;

class CateoryAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $categories = app(CategoriesTask::class)->setDto($this->dto)->run();
        return $categories
    }

}
