# encoding: utf-8
namespace :insides do

  desc 'Переустанавливает статусы инсайдов'
  task reinstall: :environment do
    Core::Insides::rebuild
  end

end