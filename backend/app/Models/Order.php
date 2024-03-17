<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
	use SoftDeletes;
	
    protected $table = 'order';

    protected $guarded = ['id'];


	public function items()
    {
        return $this->hasMany('App\Models\OrderItems');
    }
	

}
