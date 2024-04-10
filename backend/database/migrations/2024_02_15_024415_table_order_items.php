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
        Schema::create('order_items', function (Blueprint $table) {
            $table->id();
			$table->integer('order_uid');
			$table->string('item_uid');
			$table->string('code')->nullable();
			$table->string('bar_code')->nullable();
            
            $table->string('name')->nullable();
			$table->integer('quantity')->default(0);
			$table->decimal('price', 9, 3)->nullable();
			$table->decimal('discount', 9, 3)->nullable();

            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('menu');
    }
};
