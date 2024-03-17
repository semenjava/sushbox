<?php

namespace App\Services\Simplelivepos\Job;

use App\Models\Category;
use App\Models\Menu;

class MenuJob
{
    private array $data;
	private Category $category;
	private Menu $menu;

    public function __construct(array $data, Category $category, Menu $menu) 
    {
        $this->data = $data;
		$this->category = $category;
		$this->menu = $menu;
    }

    public function run()
    {
		$this->menu->bar_code = $this->data['barCode'];
		$this->menu->name = $this->data['name'];
		$this->menu->name_en = $this->data['name'];
		$this->menu->comments = $this->data['comments'];
		$this->menu->image = $this->data['image'];
		$this->menu->position = $this->data['position'];
		
		$this->menu->update_at = $this->data['updatedAt'];
		$this->menu->delete_at = !empty($this->data['delete']) ? $this->data['updatedAt'] : null;
		
		$this->menu->save();
    }
}
