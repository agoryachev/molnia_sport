# encoding: utf-8
namespace :stat do

  desc "аггрегирует статистику по хитам и хостам в новостях, галлереях и видео"
  task aggr: :environment do
    puts 'aggregation started'
    Statistics::Aggregate.new
    puts 'aggregation finished'
  end

end