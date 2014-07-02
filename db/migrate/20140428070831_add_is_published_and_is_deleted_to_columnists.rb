# -*- coding: utf-8 -*-
class AddIsPublishedAndIsDeletedToColumnists < ActiveRecord::Migration
  def change
    add_column :columnists, :is_published, :boolean, default: false, after: :content, comment: '1 - опубликовано (отображается), 0 - не опубликовано (не отображается)'
    add_column :columnists, :is_deleted, :boolean, default: false, after: :is_published, comment: '1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись'
  end
end
