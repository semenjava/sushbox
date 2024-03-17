<?php

namespace Modules\GraphQL\Http\Queries;

use Modules\GraphQL\Http\Actions\CateoryAction;

final class CategoryQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(CateoryAction::class)->setDto($args)->run();
    }
}
