# mina-laravel

mina-laravel is a gem that adds many tasks to aid in the deployment of [laravel] (http://laravel.com) applications
using [Mina] (http://nadarei.co/mina).

# Getting Start

## Instalation
	
	gem install mina-laravel

## Configuration

After installation, create a file in the root directory of your project called `Minafile`.

Note: Mina uses the command `mina init` to create a config file at `config/deploy.rb`, but laravel use the `Config` directory to hold configurations.
To avoid problems we recommend using `Minafile` instead of `config/deploy.rb`

`Minafile` sample:
```ruby
require 'mina/git'
require 'mina-laravel'
# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :user, 'deploy'
set :domain, 'antesky.com'
set :deploy_to, '/home/deploy/www/App'
set :repository, 'git@git.coding.net:someone/App.git'
set :branch, 'master'

set :shared_paths, ['.env', 'storage', 'vendor', 'node_modules', 'public/uploads']

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'

    queue 'composer install'
    queue 'php artisan migrate --force'

    invoke :'laravel:build_assets'

    invoke :'deploy:cleanup'
    to :launch do
      queue 'composer dumpautoload'
      queue 'php artisan optimize'
    end
  end
end
```


## Setup Environment

	mina setup

More at http://nadarei.co/mina/directory_structure.html

## Deploying

	mina deploy

More at http://nadarei.co/mina/deploying.html

## Tail log from server

	mina log

## More tasks

Run

	mina -T

To list all tasks.

## Contributing to mina-laravel
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 kikyous.
