# encoding: utf-8
class AddRowsToEmployee < ActiveRecord::Migration
  def change
    change_table(:employees) do |t|
      t.boolean    :is_published,      default: true,                comment: "Показывать сотрудника"
      t.text       :description,                                     comment: "Описание сотрудника"
      t.string     :position,          default: "",                  comment: "Статус сотрудника"
      t.integer    :placement_index,   default: 0,                   comment: "Позиция сотрудника"
      t.boolean    :show_publications, default: true,                comment: "Показывать публикации"
    end
  end
end
