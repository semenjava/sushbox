<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Category;

class CategoriesTask extends BaseTask
{
    public function run()
    {
        return Category::all();
    }
}