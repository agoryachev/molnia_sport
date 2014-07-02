# encoding: utf-8
class FeedsUniqueIndex < ActiveRecord::Migration
  def change
    # Уникальный индекс для предотвращения вставки дублирующих значений
    add_index :feeds, [:feedable_id, :feedable_type], unique: true
  end
end