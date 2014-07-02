# encoding: utf-8
# == Schema Information
#
# Table name: comments # Комментарии пользователей
#
#  id               :integer          not null, primary key
#  title            :string(50)       default(""), not null    # Заголовок комментария
#  content          :text             default(""), not null    # Тело комментария
#  commentable_id   :integer          not null                 # Внешний ключ для комментируемого материала
#  commentable_type :string(255)      not null                 # Внешний ключ для комментируемого материала
#  user_id          :integer          not null                 # Внешний ключ для связи с таблицей frontend-пользователей user
#  is_published     :boolean          default(FALSE)           # 1 - комментарий доступен для просмотра, 0 - комментарий скрыт
#  is_deleted       :boolean          default(FALSE), not null # 1 - комментарий удален (фактически скрыт без возможности отображения), 0 - обычный комментарий
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryGirl.define do
  factory :comment do

    title            Faker::Lorem.words(3).join(" ")
    content          Faker::Lorem.words(15).join(" ")
    commentable_id   1
    commentable_type "Post"
    user_id          1
    is_published     1
    is_deleted       0

  end
end