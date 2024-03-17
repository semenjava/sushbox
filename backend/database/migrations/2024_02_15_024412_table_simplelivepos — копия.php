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
        Schema::create('simplelivepos', function (Blueprint $table) {
            $table->id();
            $table->string('ip');
            $table->text('token');
            $table->string('companyId');
            $table->json('data');
            $table->tinyInteger('status')->default(1)->unsigned();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('simplelivepos');
    }
};
