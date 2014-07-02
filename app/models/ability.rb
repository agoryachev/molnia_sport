# encoding: utf-8
# == Schema Information
#
# Table name: abilities
#
#  id           :integer          not null, primary key
#  context      :string(255)
#  ability_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

##########################################
# Возможность доступа
#
# Проверка доступа:
# - к экшену контроллера 
# current_employee.action_abilities.exists?(context: "controllers.posts.index")
# - к атрибуту модели
# current_employee.attr_abilities.exists?(context: "models.posts.subtitle")
# - к partial
# current_employee.partial_abilities.exists?(context: "partials.menu.settings")
##########################################
class Ability < ActiveRecord::Base
  attr_accessible :ability_type, :context

  has_many :group_abilities, dependent: :destroy
  has_many :groups, through: :group_abilities

  class << self
    # Рекурсивно сливает ключи хеша
    # 
    # * *Args*    :
    #   - +collect+ Array для аккумулирования результата
    #   - +contexts+ Hash который необходимо слить
    # * *Returns* :
    #   - Array массивов с ключами [["key","key.key1","key.key2"],["key","key.key1","key.key2"]]
    #
    def merge_keys_recursively(collect,contexts)
      contexts.each_key do |k|
        if contexts[k].kind_of?(Hash)
          merge_keys_recursively(collect << [k],contexts[k])
        else
          if collect.last && collect.last.kind_of?(Array)
            collect.last << [collect.last[0],k].join('.')
          else
            collect << k
          end
        end
      end
      collect
    end

    # Импортирует контексты(contexts) в таблицу abilities из config/locales/context.yml
    # 
    # * *Returns* :
    #   - Boolean - true
    #
    def import
      raise RuntimeError.new("CONTEXT not defined") unless defined?(CONTEXT)

      Ability.destroy_all
      connection.execute("TRUNCATE TABLE abilities;")

      CONTEXT["controllers"].delete("default")
      CONTEXT.each do |entry|
        type    = entry[0]
        contexts = entry[1]
        merged_contexts = merge_keys_recursively([], contexts)
          .map{|e| 
            e.kind_of?(Array) ? e.delete_at(0) && e : e
          }
          .flatten
          .map{|e|
            [type,e].join('.')
          }
        merged_contexts.each do |context|
          Ability.find_or_create_by_ability_type_and_context(type,context)
        end
      end
      
      if group = Group.find_by_title("administrators")
        group.ability_ids=Ability.pluck(:id)
        group.save
      end
      
      true
    end  
  end

end
