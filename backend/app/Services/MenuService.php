<?php
namespace App\Services;

use App\Models\Menu;

class MenuService
{
    protected $menu;

    public function __construct(Menu $menu)
    {
        $this->menu = $menu;
    }

    public function getMenus()
    {
        $categories = $this->menu->pluck('name', 'id');
        return $categories;
    }
}