<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\UsersTask;

class UsersAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $users = app(UsersTask::class)->setDto($this->dto)->run();

        $data = $users->items();
        return [
            'data' => $data,
            'paginatorInfo' => [
                'count' => $users->count(),
                'currentPage' => $users->currentPage(),
                'firstItem' => $users->firstItem(),
                'lastItem' => $users->lastItem(),
                'perPage' => $users->perPage(),
                'hasMorePages' => $users->hasMorePages(),
            ]
        ];
    }

}
