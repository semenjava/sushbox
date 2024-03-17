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
        Schema::create('category', function (Blueprint $table) {
            $table->id();
			$table->string('parent_id')->nullable();
			$table->string('code');
            $table->string('name')->nullable();
			$table->string('name_en')->nullable();
			$table->string('image')->nullable();
			$table->tinyInteger('is_product_category')->default(0);
			$table->tinyInteger('is_ingredient_category')->default(0);
			$table->tinyInteger('is_preparation_category')->default(0);
			$table->tinyInteger('show_preferences')->default(0);
			$table->int('position')->default(0);
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('category');
    }
};
