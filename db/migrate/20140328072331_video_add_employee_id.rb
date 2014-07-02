# encoding: utf-8
class VideoAddEmployeeId < ActiveRecord::Migration
  def change

    change_column :leagues, :country_id, :integer, after: 'category_id'
    set_column_comment :leagues, :country_id, 'Внешний ключ для связи с странами'

    change_column :posts, :employee_id, :integer, after: 'category_id'
    set_column_comment :posts, :employee_id, 'Внешний ключ для связи с сотрудниками'

    add_column :videos, :employee_id, :integer, after: 'category_id', comment: 'Внешний ключ для связи с сотрудниками'

  end
end