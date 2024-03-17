<?php

namespace Modules\GraphQL\database\seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Modules\Tag\Models\GraphQL;

class GraphQLDatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Disable foreign key checks!
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        /*
         * GraphQLs Seed
         * ------------------
         */

        // DB::table('graphqls')->truncate();
        // echo "Truncate: graphqls \n";

        GraphQL::factory()->count(20)->create();
        $rows = GraphQL::all();
        echo " Insert: graphqls \n\n";

        // Enable foreign key checks!
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');
    }
}
