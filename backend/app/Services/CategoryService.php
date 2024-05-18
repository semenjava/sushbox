<?php
namespace App\Services;

use App\Models\Category;

class CategoryService
{
    protected $category;

    public function __construct(Category $category)
    {
        $this->category = $category;
    }

    public function getCategories()
    {
        $categories = $this->category->pluck('name', 'id');
        return $categories;
    }
}