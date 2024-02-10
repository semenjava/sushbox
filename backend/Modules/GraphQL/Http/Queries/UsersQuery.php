<?php

namespace Modules\GraphQL\Http\Queries;

use Modules\GraphQL\Http\Actions\UsersAction;

final class UsersQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(UsersAction::class)->setDto($args)->run();
    }
}
