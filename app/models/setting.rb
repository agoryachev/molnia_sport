# encoding: utf-8
# == Schema Information
#
# Table name: settings # Таблица с настройками, расширяющая app.yml
#
#  id      :integer          not null, primary key
#  name    :string(255)                            # Имя параметра
#  content :string(256)                            # Содержание
#

class Setting < ActiveRecord::Base

  attr_protected ''

  before_update :check_selected_match

  class << self
    def method_missing m, *args
      #super.method_missing m, *args
      if APP && APP[m.to_s]
        APP[m.to_s]
      elsif s = self.where(name: m).first
        s.content
      end
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def find_by_name name
      result = self.where(name: name).limit(1)
      result[0] unless result.nil?
    end

    def show_sidebar_banner?
      side_bar_banner.to_i == 1
    end

    def show_match_live?
      match_live.to_i == 1
    end
  end

  # Если изменяется настрока показа сайдбара с матчем
  # Мы проверяем, выбран ли вообще матч для показа в сайдбара
  # Если нет, то выдаем ошибку
  def check_selected_match
    if name == 'match_live' && content_changed? && content == '1' && !Match.any_for_sidebar?
      errors.add(:match_selected_error, "Вы не выбрали матч для показа в сайдбаре")
      false
    end
  end

end
