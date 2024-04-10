<?php

namespace Modules\Menu\Models;

use App\Models\HomeModel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Category;

class Menu extends HomeModel
{
    use HasFactory;
    use SoftDeletes;

    protected $table = 'menu';
}
