# encoding: utf-8
class AddFieldsForPlayOffToMatches < ActiveRecord::Migration
  def change
    add_column :leagues_groups, :round_type,  :integer, default: 0,   after: :title,       comment: "Тип тура (групповой / плей-офф)"
    add_column :leagues_groups, :start_stage, :integer, default: nil, after: :round_type,  comment: "Стартовая стадия"

    add_column :matches,        :side,               :integer, default: 1,   after: :finish_at, comment: "Корзина для плей-офф"
    add_column :matches,        :stage,              :integer, default: nil, after: :side,      comment: "Стадия для плей-офф"
    add_column :matches,        :position_in_stage,  :integer, default: nil, after: :stage,     comment: "Позиция матча внутри стадии для плей-офф"
  end
end
