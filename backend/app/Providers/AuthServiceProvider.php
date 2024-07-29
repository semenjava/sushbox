<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Laravel\Passport\Passport;
use Illuminate\Support\Facades\Auth;
use App\Services\TokenGuard;
use App\Providers\TokenUserProvider;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array
     */
    protected $policies = [
        'App\Model' => 'App\Policies\ModelPolicy',
    ];

    /**
     * Register any authentication / authorization services.
     *
     * @return void
     */
    public function boot()
    {
        Auth::extend('token', function ($app, $name, array $config) {
            $userProvider = Auth::createUserProvider($config['provider']);

            $request = $app['request'];

            return new TokenGuard($userProvider, $request);
        });

        $this->registerPolicies();

        Passport::routes();
    }
}
