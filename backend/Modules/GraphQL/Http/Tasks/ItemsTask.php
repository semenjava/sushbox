<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Items;

class ItemsTask extends BaseTask
{
    private $items;

    public function __construct()
    {
        $this->items = new Items;
    }

    public function run()
    {
        $category = $this->getDto()->get('category');
        $page = $this->getDto()->get('page') ?? 0;
        $first = $this->getDto()->get('first');

        return $this->items->where('name', 'like', '%'.$category.'%')->paginate($first, ['*'], 'page', $page);
    }
}