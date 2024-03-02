<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;

class Simplelivepos extends Model
{
    use SoftDeletes;

    protected $table = 'simplelivepos';
    
    protected $fillable =
    [
        'ip',
        'token',
        'status',
        'companyId',
        'data'
    ];

    public function getToken()
    {
        return $this->token;
    }

    public function getCompanyId() 
    {
        return $this->companyId;
    }

}
