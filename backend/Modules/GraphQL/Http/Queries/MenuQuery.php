<?php

namespace Modules\GraphQL\Http\Queries;

use Modules\GraphQL\Http\Actions\MenuAction;

final class MenuQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(MenuAction::class)->setDto($args)->run();
    }
}
