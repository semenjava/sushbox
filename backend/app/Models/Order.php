<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
	use SoftDeletes;

    const STATUS_IN_PROCESS = 'in_process';
    const STATUS_FINISH = 'finish';
    const STATUS_PAYMENTS = 'paymets';
    const STATUS_DELIVERY = 'delivery';
	
    protected $table = 'order';

    protected $guarded = ['id'];


	public function items()
    {
        return $this->hasMany('App\Models\OrderItems', 'order_uid', 'uuid');
    }
	
    public function isProcess() 
    {
        return $this->status == self::STATUS_IN_PROCESS;
    }

    public function payment()
    {
        return $this->belongsTo('App\Models\Payment', 'payment_uid', 'uuid');
    }

    public function isPaymets()
    {
        return $this->status == self::STATUS_PAYMENTS;
    }

    public function isDelivery()
    {
        return $this->status == self::STATUS_DELIVERY;
    }

    public function isFinish()
    {
        return $this->status == self::STATUS_FINISH;
    }
    
}
