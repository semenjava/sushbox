<?php

namespace Modules\GraphQL\Http\Queries;

use Modules\GraphQL\Http\Actions\ItemsAction;

final class ItemsQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(ItemsAction::class)->setDto($args)->run();
    }
}
