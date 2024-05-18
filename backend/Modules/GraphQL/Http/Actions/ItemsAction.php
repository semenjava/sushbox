<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\ItemsTask;

class ItemsAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $items = app(ItemsTask::class)->setDto($this->dto)->run();
        return $items->orderBy('position');

        // $data = $items->items();
        // return [
        //     'data' => $data,
        //     'paginatorInfo' => [
        //         'count' => $items->count(),
        //         'currentPage' => $items->currentPage(),
        //         'firstItem' => $items->firstItem(),
        //         'lastItem' => $items->lastItem(),
        //         'perPage' => $items->perPage(),
        //         'hasMorePages' => $items->hasMorePages(),
        //     ]
        // ];
    }

}
