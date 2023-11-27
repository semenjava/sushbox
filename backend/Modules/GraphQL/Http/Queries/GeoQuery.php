<?php

namespace App\GraphQL\Queries;

use Modules\StaticPage\Http\Actions\GeoAction;

final class GeoQuery
{
    /**
     * @param null $_
     * @param array{} $args
     */
    public function __invoke($_, array $args)
    {
        return app(GeoAction::class)->setDto($args)->run();
    }
}
