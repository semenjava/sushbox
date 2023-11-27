<?php

namespace App\GraphQL\Mutations;

use Modules\Products\Http\Actions\DeleteWishlistAction;

final class DeleteWishlistMutation
{
    /**
     * @param  null  $_
     * @param  array{}  $args
     */
    public function __invoke($_, array $args)
    {
        return app(DeleteWishlistAction::class)->setDto($args)->run();
    }
}
