# -*- coding: utf-8 -*-
set :rvm_ruby_string, 'ruby-2.1.2'
set :rvm_type, :user

set :rails_env,   "production"
set :unicorn_env, rails_env
set :app_env,     rails_env
set :application, "molniasport.ru"
set :deploy_to, "/var/www/#{application}"
set :scm, :git
set :repository,  "git@git.nnbs.ru:go/sport.git"
set :scm_verbose, true
set :branch, ENV["BRANCH"] || "master"
set :user, "molniasport"
set :use_sudo, false
set :keep_releases, 2
set :git_shallow_clone, 1

role :app, "molniasport.ru"
role :db,  "molniasport.ru", primary: true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn/#{rails_env}.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :thin_conf, "#{deploy_to}/current/config/thin/#{rails_env}.yml"
set :thin_pid, "#{deploy_to}/shared/pids/thin.pid"

set :whenever_command, 'bundle exec whenever'

require 'thinking_sphinx/capistrano'
require 'rvm/capistrano'
require 'whenever/capistrano'

before "deploy:update_code", "thinking_sphinx:stop"
after "deploy:update_code", "thinking_sphinx:start"
after 'deploy:finalize_update', "assets:deploy"

before 'deploy', "assets:precompile"
after "deploy:update_code", "db:migrate"
after "deploy", "deploy:cleanup"


namespace :assets do
  desc "Компиляция ассетов локально и загрузка в директорию релиза"
  
  task :precompile, except: { no_release: true } do
    run_locally <<-CMD
        rake assets:clean && 
        nice -n 19 rake assets:precompile && 
        cd public && 
        tar -zcf assets.tar.gz assets
      CMD
  end  

  task :deploy, except: { no_release: true } do
    upload "public/assets.tar.gz", "#{release_path}/public", via: :scp, recursive: true
    run "cd #{release_path}/public && tar -xf assets.tar.gz && rm assets.tar.gz"
    run_locally "cd public && rm -rf assets*"
  end
end

namespace :db do
  desc "Операции с базами данных"
  task :migrate, roles: :db, only: { primary: true } do
    run "cd #{release_path} && bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
  end
end

namespace :deploy do
  desc "Управление unicorn и thin"
  task :restart, roles: :app do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
    run "cd #{deploy_to}/current && bundle exec thin -C #{thin_conf} -O restart"
  end
  task :start, roles: :app do
    run "cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
    run "cd #{deploy_to}/current && bundle exec thin -C #{thin_conf} start"
  end
  task :stop, roles: :app do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
    run "cd #{deploy_to}/current && bundle exec thin -C #{thin_conf} stop"
  end
end

namespace :sphinx do
  desc "Symlink Sphinx indexes"
  task :symlink_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end
end
