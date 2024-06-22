<?php

namespace Modules\Slider\Entities;

use App\Models\HomeModel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Category;

class Image extends HomeModel
{
    protected $table = 'images';

    protected $guarded = ['id'];
}
