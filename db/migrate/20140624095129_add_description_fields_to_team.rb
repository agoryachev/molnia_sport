# encoding: utf-8
class AddDescriptionFieldsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :year_of_foundation, :string,  after: :subtitle,    comment: "Год основания команды"
    add_column :teams, :coach_id,           :integer, after: :category_id, comment: "id тренера"
  end
end
