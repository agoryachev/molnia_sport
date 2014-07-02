# encoding: utf-8
namespace :settings do

  desc 'Переустанавливает/обнуляет настройки сайта'
  task reinstall: :environment do
    Core::Settings::rebuild
  end

end