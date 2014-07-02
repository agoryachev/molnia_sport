# encoding: utf-8
class AddIsPublColumnsToTacticalSchemes < ActiveRecord::Migration
  def change
    add_column :tactical_schemes, :is_published, :boolean, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
    add_column :tactical_schemes, :is_deleted, :boolean, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
  end
end
