<?php

namespace Modules\Category\Models;

use App\Models\HomeModel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class Category extends HomeModel
{
    use HasFactory;
    use SoftDeletes;

    protected $table = 'category';

    protected $fillable = [
        'parent_id',
        'code',
        'name',
        'name_en',
        'image',
        'is_product_category',
        'is_ingredient_category',
        'is_preparation_category',
        'show_preferences',
        'position',
    ];

}
