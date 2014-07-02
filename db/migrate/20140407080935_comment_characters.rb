# encoding: utf-8
class CommentCharacters < ActiveRecord::Migration
  def change
    set_table_comment :characters, "Амплуа персоналии, гл.тренер, полузащитник и т.п."
  end
end