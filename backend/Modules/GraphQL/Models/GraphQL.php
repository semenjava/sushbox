<?php

namespace Modules\GraphQL\Models;

use App\Models\BaseModel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class GraphQL extends BaseModel
{
    use HasFactory;
    use SoftDeletes;

    protected $table = 'graphqls';

    /**
     * Create a new factory instance for the model.
     *
     * @return \Illuminate\Database\Eloquent\Factories\Factory
     */
    protected static function newFactory()
    {
        return \Modules\GraphQL\database\factories\GraphQLFactory::new();
    }
}
