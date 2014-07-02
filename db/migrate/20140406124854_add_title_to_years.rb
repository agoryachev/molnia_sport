# encoding: utf-8
class AddTitleToYears < ActiveRecord::Migration
  def change
    add_column :years, :title, :string, after: :id, comment: 'Название сезона. Например: 2006/2007'
  end
end
