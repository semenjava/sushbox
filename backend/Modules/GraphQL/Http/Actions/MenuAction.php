<?php

namespace Modules\GraphQL\Http\Actions;

use Components\Modules\Actions\BaseAction;
use Modules\GraphQL\Http\Tasks\MenusTask;

class MenuAction extends BaseAction
{
    /**
     * Display a listing of the resource.
     * @return array
     */
    public function run()
    {
        $menus = app(MenusTask::class)->setDto($this->dto)->run();

        return $menus->orderBy('position');
    }

}
