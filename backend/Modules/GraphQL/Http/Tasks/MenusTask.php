<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Menu;

class MenusTask extends BaseTask
{
    public function run()
    {
        return Menu::all();
    }
}