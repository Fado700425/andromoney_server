require 'bundler/capistrano'
require 'capistrano/local_precompile'
# require 'hoptoad_notifier/capistrano'

set :application, "andromoney_server"
set :rails_env, "production"

#set :branch, "master"
set :branch, "dev"
set :repository,  "https://github.com/StevenKo/andromoney_server.git"
set :scm, "git"
set :user, "apps" # 一個伺服器上的帳戶用來放你的應用程式，不需要有sudo權限，但是需要有權限可以讀取Git repository拿到原始碼
set :port, "22"

set :deploy_to, "/home/apps/andromoney_server"
set :deploy_via, :remote_cache
set :use_sudo, false


#測試的
role :web, "106.186.122.183" 
role :app, "106.186.122.183"
role :db,  "106.186.122.183", :primary => true

set :bundle_cmd, "RAILS_ENV=production bundle"

# 正式的

#role :web, "106.186.22.13"
#role :app, "106.186.22.13"
#role :db,  "106.186.22.13", :primary => true

#run("cd #{deploy_to}/current && /usr/bin/env rake db:migrate RAILS_ENV=production")

namespace :deploy do

  task :copy_config_files, :roles => [:app] do
    db_config = "#{shared_path}/config/database.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
    local_config = "#{shared_path}/config/application.yml"
    run "cp #{local_config} #{release_path}/config/application.yml"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)
 
# namespace :deploy do
#   namespace :assets do
 
#     desc <<-DESC
#       Run the asset precompilation rake task. You can specify the full path \
#       to the rake executable by setting the rake variable. You can also \
#       specify additional environment variables to pass to rake via the \
#       asset_env variable. The defaults are:
 
#         set :rake,      "rake"
#         set :rails_env, "production"
#         set :asset_env, "RAILS_GROUPS=assets"
#         set :assets_dependencies, fetch(:assets_dependencies) + %w(config/locales/js)
#     DESC
#     task :precompile, :roles => :web, :except => { :no_release => true } do
#       from = source.next_revision(current_revision)
#       if capture("cd #{latest_release} && #{source.local.log(from)} #{assets_dependencies.join ' '} | wc -l").to_i > 0
#         run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#       else
#         logger.info "Skipping asset pre-compilation because there were no asset changes"
#       end
#     end
 
#   end
# end


before "deploy:assets:precompile", "deploy:copy_config_files" # 如果將database.yml放在shared下，請打開
after "deploy:update_code", "deploy:copy_config_files" # 如果將database.yml放在shared下，請打開
# after "deploy:finalize_update", "deploy:update_symlink" # 如果有實作使用者上傳檔案到public/system，請打開
