# -*- coding: utf-8 -*-
class Core::Insides

  # Переустановка статусов инсайдов
  #
  # @return [Boolean] true в случае успешной переустановки статусов инсайдов
  #
  def self.rebuild

    ActiveRecord::Base.connection.execute('TRUNCATE TABLE `inside_statuses`')
    ['Переговоры ведутся', 'Слухи', 'Официально'].each do |status|
      if status === 'Официально'
        color = 'green'
      else
        color = 'red'
      end
      InsideStatus.create!({title: status, color: color})
    end

  end

end