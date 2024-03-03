<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\Items;
use App\Models\Menu;

class ItemsTask extends BaseTask
{
    private $items;

    public function __construct()
    {
        $this->items = new Items;
    }

    public function run()
    {
        $menu_id = $this->getDto()->get('menu_id');
		$menu = Menu::find($menu_id);
		$category_id = $menu->category_id;

        return $this->items->where('category_id', $category_id)->orderBy('position')->get();//->paginate($first, ['*'], 'page', $page);
    }
}