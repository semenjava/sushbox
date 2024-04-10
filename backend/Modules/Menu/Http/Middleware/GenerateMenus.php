<?php

namespace Modules\Menu\Http\Middleware;

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
            // Menu
            $menu->add('<i class="nav-icon fa-solid fa-sitemap"></i> '.__('Menu'), [
                'route' => 'backend.menu.index',
                'class' => 'nav-item',
            ])
                ->data([
                    'order' => 83,
                    'activematches' => ['admin/menu*'],
                    'permission' => ['view_menu'],
                ])
                ->link->attr([
                    'class' => 'nav-link',
                ]);
        })->sortBy('order');

        return $next($request);
    }
}
