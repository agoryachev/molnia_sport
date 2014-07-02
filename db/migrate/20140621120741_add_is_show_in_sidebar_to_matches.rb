# encoding: utf-8
class AddIsShowInSidebarToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :is_show_in_sidebar, :boolean, unsigned: true, null: false, default: false, after: :is_comments_enabled, comment: '1-Показывать в садбаре, 2-Скрыть из сайдбара'
  end
end
