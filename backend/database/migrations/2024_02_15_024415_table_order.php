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
        Schema::create('order', function (Blueprint $table) {
            $table->id();
			$table->integer('uid');
			$table->string('message_owner_id')->nullable();
			$table->string('status')->nullable();
			$table->integer('items_count')->nullable();

			$table->decimal('price', 9, 3)->nullable();
			$table->decimal('delivery_price', 9, 3)->nullable();
			$table->decimal('full_price', 9, 3)->nullable();

			$table->string('payment_uid')->nullable();

			$table->json('data')->nullable();
            
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
