# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, "andromoney_server"
set :repo_url, 'git@github.com:timeflying/andromoney_server.git'
# set :repo_url, 'andromoney-tilumi:tilumi/andromoney_server.git'

set :deploy_to, '/home/apps/andromoney_server'
set :scm, :git
set :branch, 'dev'
# set :branch, 'debug_deploy_errors'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :bower do
 desc 'Install bower'
 task :install do
   on roles(:web) do
     within release_path do
       execute :rake, 'bower:install CI=true'
     end
   end
 end
end
before 'deploy:compile_assets', 'bower:install'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  #after :restart, 'deploy:sitemap:refresh'

end
