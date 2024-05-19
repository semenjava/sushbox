<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class OrderItems extends Model
{
	use SoftDeletes;
	
    protected $table = 'order_items';

    protected $guarded = ['id'];

	
	public function order()
    {
        return $this->belongsTo('App\Models\Order', 'order_uid', 'uuid');
    }

    public function item()
    {
        return $this->belongsTo('App\Models\Items', 'item_uid', 'uuid');
    }

}
