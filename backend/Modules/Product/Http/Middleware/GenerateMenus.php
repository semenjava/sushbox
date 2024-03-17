<?php

namespace Modules\Product\Http\Middleware;

use Closure;

class GenerateMenus
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        /*
         *
         * Module Menu for Admin Backend
         *
         * *********************************************************************
         */
        \Menu::make('admin_sidebar', function ($menu) {
            // Products
            $menu->add('<i class="nav-icon fa-solid fa-sitemap"></i> '.__('Products'), [
                'route' => 'backend.products.index',
                'class' => 'nav-item',
            ])
                ->data([
                    'order' => 83,
                    'activematches' => ['admin/products*'],
                    'permission' => ['view_products'],
                ])
                ->link->attr([
                    'class' => 'nav-link',
                ]);
        })->sortBy('order');

        return $next($request);
    }
}
