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
        Schema::create('menu', function (Blueprint $table) {
            $table->id();
			$table->integer('category_id');
			$table->string('code');
			$table->string('bar_code')->nullable();
            $table->string('name')->nullable();
			$table->string('name_en')->nullable();
			$table->string('comments')->nullable();
			$table->string('image')->nullable();
			$table->integer('position')->default(0);
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
