# encoding: utf-8
class RenameColumnAliasToSlugInSeos < ActiveRecord::Migration
  def up
    rename_column :seos, :alias, :slug
    set_column_comment :seos, :slug, "ЧПУ - человекопонятный урл"
  end

  def down
    rename_column :seos, :slug, :alias
    set_column_comment :seos, :alias, "Каноническое имя (canonical) для URL"
  end
end
