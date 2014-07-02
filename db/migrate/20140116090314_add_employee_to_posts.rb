# encoding: utf-8
class AddEmployeeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :employee_id, :integer, comment: 'Свзяь с сотрудниками'
  end
end
