<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;


class Items extends HomeModel
{
	use SoftDeletes;
	
    protected $table = 'items';

    protected $guarded = ['id'];
	
	public function category()
    {
        return $this->belongsTo(Category::class);
    }

}
