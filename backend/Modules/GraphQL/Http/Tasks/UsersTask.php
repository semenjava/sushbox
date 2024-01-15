<?php

namespace Modules\GraphQL\Http\Tasks;

use Components\Modules\Tasks\BaseTask;
use App\Models\User;

class UsersTask extends BaseTask
{
    private $user;

    public function __construct()
    {
        $this->user = new User;
    }

    public function run()
    {
        $name = $this->getDto()->get('name');
        $page = $this->getDto()->get('page') ?? 0;
        $first = $this->getDto()->get('first');

        return $this->user->where('name', 'like', '%'.$name.'%')->paginate($first, ['*'], 'page', $page);
    }
}