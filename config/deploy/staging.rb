# -*- coding: utf-8 -*-

set :rails_env,   "staging"
set :unicorn_env, rails_env
set :app_env,     rails_env
set :application, "sport.nnbs.ru"
set :deploy_to, "/var/www/#{application}"
set :scm, :git
set :repository,  "git@git.nnbs.ru:go/sport.git"
set :scm_verbose, true
set :branch, ENV["BRANCH"] || "dev"
set :user, "sport"
set :use_sudo, false
set :keep_releases, 2
set :git_shallow_clone, 1

role :app, "sport.nnbs.ru"
role :db,  "sport.nnbs.ru", primary: true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn/#{rails_env}.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :thin_conf, "#{deploy_to}/current/config/thin/#{rails_env}.yml"
set :thin_pid, "#{deploy_to}/shared/pids/thin.pid"

set :whenever_command, 'bundle exec whenever'

require 'thinking_sphinx/capistrano'
require 'whenever/capistrano'

before 'deploy', "assets:precompile"
before 'deploy:restart', "assets:deploy"
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
    upload "public/assets.tar.gz", "#{deploy_to}/current/public", via: :scp, recursive: true
    run "cd #{deploy_to}/current/public && tar -xf assets.tar.gz && rm assets.tar.gz"
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
