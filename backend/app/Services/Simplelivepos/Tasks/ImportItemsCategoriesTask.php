<?php

namespace App\Services\Simplelivepos\Tasks;

use App\Models\Category;
use App\Models\Menu;
use App\Models\Items;
use App\Services\Simplelivepos\Job\CategoryJob;
use App\Services\Simplelivepos\Job\MenuJob;
use App\Services\Simplelivepos\Job\ItemJob;

class ImportItemsCategoriesTask
{
    private array $data;
	
	private Category $category;
	private Menu $menu;
	private Items $item;
	
	private array $categories;
	private array $menus;
	private array $items;

    public function __construct(array $data) 
    {
        $this->data = $data;
		
		$this->category = new Category;
		$this->menu = new Menu;
		$this->item = new Items;
		
		$this->init();
    }
	
	private function init() 
	{
		$this->categories = $this->data['parentCategory'] ?? null;
		//$this->menus = $this->data['parentCategory']['menuItems'] ?? null;
		//$this->items = $this->data['parentCategory']['items'] ?? null;
	}

    public function run()
	{
		foreach($this->categories as $cat) {
			$category = Category::firstOrNew(
				['code' =>  $cat['code']]
			);
			
			(new CategoryJob($cat, $category))->run();
			
			foreach($this->data['parentCategory']['menuItems'] as $m) {
				$menu = Menu::firstOrNew(
					['code' =>  $m['code'], 'category_id' => $category->id]
				);
				
				(new MenuJob($m, $category, $menu))->run();
			}
			
			foreach($this->data['parentCategory']['items'] as $itm) {
				$item = Items::firstOrNew(
					['code' =>  $itm['code'], 'category_id' => $category->id]
				);
				
				(new ItemJob($itm, $category, $item))->run();
			}
		}
		
	}
}
