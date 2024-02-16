<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

class Simplelivepos extends BaseModel
{
    use SoftDeletes;

    protected $table = 'simplelivepos';
    
    protected $fillable =
    [
        'ip',
        'token',
        'status',
    ];


}
