# encoding: utf-8
namespace :permissions do

  desc 'Переустанавливает права доступа'
  task reinstall: :environment do
    Core::Permissions::rebuild
  end

end