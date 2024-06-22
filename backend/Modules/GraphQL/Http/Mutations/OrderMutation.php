<?php

namespace App\GraphQL\Mutations;

use Modules\GraphQL\Http\Actions\OrderAction;

final class OrderMutation
{
    /**
     * @param  null  $_
     * @param  array{}  $args
     */
    public function __invoke($_, array $args)
    {
        return app(OrderAction::class)->setDto($args)->run();
    }
}
