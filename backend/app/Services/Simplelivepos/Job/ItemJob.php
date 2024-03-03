<?php

namespace App\Services\Simplelivepos\Job;

use App\Models\Category;
use App\Models\Items;

class ItemJob
{
    private array $data;
	private Category $category;
	private Items $item;

    public function __construct(array $data, Category $category, Items $item) 
    {
        $this->data = $data;
		$this->category = $category;
		$this->item = $item;
    }

    public function run()
    {
		$this->item->uid = $this->data['id'];
        $this->item->bar_code = $this->data['barCode'];
		$this->item->name = $this->data['name'];
		$this->item->name_en = $this->data['name'];
		$this->item->comments = $this->data['comments'];
		$this->item->image = $this->data['image'];
		$this->item->position = $this->data['position'];
		$this->item->warning = $this->data['warning'];
		$this->item->pack = $this->data['pack'];
		$this->item->optimal_quantity = $this->data['optimalQuantity'];
		
		$this->item->item_image = $this->data['itemImage'];
		$this->item->item_thumbnail = $this->data['itemThumbnail'];
		
		$this->item->take_out_price = $this->data['takeOutPrice'];
		$this->item->delivery_price = $this->data['deliveryPrice'];
		$this->item->last_purchase_price = $this->data['lastPurchasePrice'];
		$this->item->price = $this->data['price'];
		
		$this->item->cook_time = $this->data['cookTime'];
		$this->item->color = $this->data['color'];
		
		$this->item->is_enabled = $this->data['isEnabled'];
		$this->item->has_weight = $this->data['hasWeight'];
		$this->item->is_tngredient = $this->data['isIngredient'];
		$this->item->is_product = $this->data['isProduct'];
		$this->item->is_preparation = $this->data['isPreparation'];
		
		$this->item->update_at = $this->data['updatedAt'];
		$this->item->delete_at = !empty($this->data['delete']) ? $this->data['updatedAt'] : null;
		
		$this->item->tax_rate = json_encode((array)$this->data['taxRate']);
		
		$this->item->item_category = $this->data['itemCategory'];
		$this->item->menu_category = $this->data['menuCategory'];
		
		$this->item->branch = json_encode((array)$this->data['branchItems']);
		$this->item->item_pricebooks = json_encode((array)$this->data['itemPricebooks']);
		$this->item->item_prices = json_encode((array)$this->data['itemPrices']);
		$this->item->combo_detail_items = json_encode((array)$this->data['comboDetailItems']);

		$this->item->save();
    }
}
