# encoding: utf-8
class AddLinkToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :link, :string, null: false, default: "", comment: "ссылка на твит"
  end
end
