<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('items', function (Blueprint $table) {
		$table->id();
		
		$table->string('uid');
		$table->string('code')->nullable();
		$table->string('bar_code')->nullable();

		$table->integer('category_id');
		$table->integer('menu_id');

		$table->string('name')->nullable();
		$table->string('name_en')->nullable();
		$table->string('slug')->nullable();
		$table->string('comments')->nullable();
		$table->string('image')->nullable();
		$table->string('item_image')->nullable();
		$table->string('item_thumbnail')->nullable();
		$table->integer('warning')->default(0);
		$table->integer('pack')->default(0);
		$table->integer('optimal_quantity')->default(0);
		
		$table->decimal('take_out_price', 9, 3)->nullable();
		$table->decimal('delivery_price', 9, 3)->nullable();
		$table->decimal('last_purchase_price', 9, 3)->nullable();
		$table->decimal('price', 9, 3)->nullable();
		$table->decimal('weight', 9, 3)->default(0);
		
		$table->integer('position')->default(0);
		$table->integer('cook_time')->default(0);
		$table->integer('color')->default(0);
		
		$table->tinyInteger('status')->default(0);
		$table->tinyInteger('is_tngredient')->default(0);
		$table->tinyInteger('is_product')->default(0);
		$table->tinyInteger('is_preparation')->default(0);
		
		$table->json('tax_rate')->nullable();
		
		$table->string('item_category')->nullable();
		$table->string('menu_category')->nullable();
		
		$table->json('branch')->nullable();
		$table->json('item_pricebooks')->nullable();
		$table->json('item_prices')->nullable();
		$table->json('combo_detail_items')->nullable();
		
		$table->json('create_admin')->nullable();
				
		$table->timestamps();
		$table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('items');
    }
};
