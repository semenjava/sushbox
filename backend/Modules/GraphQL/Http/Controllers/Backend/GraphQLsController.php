<?php

namespace Modules\GraphQL\Http\Controllers\Backend;

use App\Authorizable;
use App\Http\Controllers\Backend\BackendBaseController;

class GraphQLsController extends BackendBaseController
{
    use Authorizable;

    public function __construct()
    {
        // Page Title
        $this->module_title = 'GraphQLs';

        // module name
        $this->module_name = 'graphqls';

        // directory path of the module
        $this->module_path = 'graphql::backend';

        // module icon
        $this->module_icon = 'fa-regular fa-sun';

        // module model name, path
        $this->module_model = "Modules\GraphQL\Models\GraphQL";
    }

}
