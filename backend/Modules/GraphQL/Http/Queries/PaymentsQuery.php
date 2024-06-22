<?php

namespace Modules\GraphQL\Http\Queries;

use Modules\GraphQL\Http\Actions\PaymentsAction;

final class PaymentsQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(PaymentsAction::class)->setDto($args)->run();
    }
}
