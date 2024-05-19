<?php

namespace Modules\GraphQL\Http\Queries;

use Modules\GraphQL\Http\Actions\CartAction;

final class PaymentsQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(CartAction::class)->setDto($args)->run();
    }
}
