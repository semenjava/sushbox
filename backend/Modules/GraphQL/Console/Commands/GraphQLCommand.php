<?php

namespace Modules\GraphQL\Console\Commands;

use Illuminate\Console\Command;

class GraphQLCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'command:GraphQLCommand';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'GraphQL Command description';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        return Command::SUCCESS;
    }
}
