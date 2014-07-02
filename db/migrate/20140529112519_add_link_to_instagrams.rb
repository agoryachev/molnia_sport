# encoding: utf-8
class AddLinkToInstagrams < ActiveRecord::Migration
  def change
    add_column :instagram_records, :link, :string, null: false, default: "", comment: "ссылка на фото"
  end
end
