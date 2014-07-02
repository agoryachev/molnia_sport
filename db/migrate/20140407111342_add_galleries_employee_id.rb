# encoding: utf-8
class AddGalleriesEmployeeId < ActiveRecord::Migration
  def change
    add_column :galleries, :employee_id, :integer, after: :category_id, comment: 'Внешний ключ для связи с сотрудниками'
  end
end
