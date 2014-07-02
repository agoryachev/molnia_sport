# encoding: utf-8
# == Schema Information
#
# Table name: galleries # Фотогалереи
#
#  id                   :integer          not null, primary key
#  title                :string(255)      not null                 # Заголовок фотогалереи
#  content              :string(255)                               # Описание фотогалереи
#  category_id          :integer          not null                 # Внешний ключ для связи с таблицей рубрик
#  is_published         :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted           :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled  :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  delta                :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinks)
#  gallery_photos_count :integer          default(0), not null     # Количество изображений в фотогаллереи
#  comments_count       :integer          default(0), not null     # Количество комментариев к фотогаллереи
#  published_at         :datetime         not null                 # Дата и время публикации
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :gallery do

    title                 Faker::Lorem.words(3).join(" ")
    content               Faker::Lorem.words(15).join(" ")
    category              { FactoryGirl.create(:category) }
    employee_id           1
    is_published          1
    is_deleted            0
    delta                 1
    gallery_photos_count  0
    comments_count        0
    published_at          Time.now

  end
end