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
			$table->int('category_id');
            $table->string('code');
			$table->string('bar_code')->nullable();
            
            $table->string('name')->nullable();
			$table->string('name_en')->nullable();
			$table->string('comments')->nullable();
			$table->string('image')->nullable();
			$table->string('item_image')->nullable();
			$table->string('item_thumbnail')->nullable();
			$table->int('warning')->default(0);
			$table->int('pack')->default(0);
			$table->int('optimal_quantity')->default(0);
			
			$table->decimal('take_out_price', 9, 3)->nullable();
			$table->decimal('delivery_price', 9, 3)->nullable();
			$table->decimal('last_purchase_price', 9, 3)->nullable();
			$table->decimal('price', 9, 3)->nullable();
			
			$table->int('position')->default(0);
			$table->int('cook_time')->default(0);
			$table->int('color')->default(0);
			
			$table->tinyInteger('is_enabled')->default(0);
			$table->tinyInteger('has_weight')->default(0);
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
