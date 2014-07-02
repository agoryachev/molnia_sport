class AddAutoToEvent < ActiveRecord::Migration
  def change
    add_column :events, :auto, :boolean, default: false
  end
end
