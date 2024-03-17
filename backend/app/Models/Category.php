<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
	use SoftDeletes;
	
    protected $table = 'category';

    protected $guarded = ['id'];


	public function items()
    {
        return $this->hasMany('App\Models\Items');
    }
	
	public function menu()
    {
        return $this->hasOne('App\Models\Menu');
    }
	

}
