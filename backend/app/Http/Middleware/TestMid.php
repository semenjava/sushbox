<?php

namespace App\Http\Middleware;

use Closure;

use Illuminate\Http\Middleware\TrustHosts as Middleware;

class TestMid
{
    /**
     * Get the host patterns that should be trusted.
     *
     * @return array
     */
    public function handle($request, Closure $next)
    {
        dd(444);
        return $next($request);
    }
}
