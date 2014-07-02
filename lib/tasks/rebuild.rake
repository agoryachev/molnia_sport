# encoding: utf-8
namespace :db do
  desc "удаляет базу данных, потом создает делает миграцию и сид"

  task :rebuild do
    puts 'start rebuild'
    puts 'drop database'
    `rake db:drop`
    puts 'create database'
    `rake db:create`
    puts 'migrate'
    `rake db:migrate`
    puts 'seed'
    `rake db:seed`
    puts 'complete rebuild'
  end
end