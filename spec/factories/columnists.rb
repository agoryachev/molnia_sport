# == Schema Information
#
# Table name: columnists # Колумнисты
#
#  id           :integer          not null, primary key
#  name_first   :string(255)                            # Имя
#  name_last    :string(255)                            # Фамилия
#  name_v       :string(255)                            # Отчество
#  content      :text                                   # Описание
#  is_published :boolean          default(FALSE)        # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted   :boolean          default(FALSE)        # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :columnist do

    name_first    Faker::Name.first_name
    name_last     Faker::Name.last_name
    content       Faker::Lorem.paragraph(3)

  end
end
