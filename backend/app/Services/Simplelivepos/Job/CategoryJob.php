<?php

namespace App\Services\Simplelivepos\Job;

use App\Models\Category;

class CategoryJob
{
    private array $data;
	private Category $category;

    public function __construct(array $data, Category $category) 
    {
        $this->data = $data;
		$this->category = $category;
    }

    public function run()
    {
		$this->category->parent_id = $this->data['parentId'];
		$this->category->name = $this->data['name'];
		$this->category->name_en = $this->data['name'];
		$this->category->image = $this->data['image'];
		$this->category->position = $this->data['position'];
		
		$this->category->is_product_category = $this->data['isProductCategory'];
		$this->category->is_ingredient_category = $this->data['isIngredientCategory'];
		$this->category->is_preparation_category = $this->data['isPreparationCategory'];
		$this->category->show_preferences = $this->data['showPreferences'];
		
		$this->category->update_at = $this->data['updatedAt'];
		
		$this->category->save();
    }
}
