# encoding: utf-8
# == Schema Information
#
# Table name: videos # Видеозаписи
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок видео-новости
#  content             :text                                      # Описание видео-ролика
#  duration            :string(255)                               # Продолжительность видео в секундах
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей категорий
#  employee_id         :integer                                   # Внешний ключ для связи с сотрудниками
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Video do
  let(:video) { FactoryGirl.create(:video) }

  subject { video }

  context 'отвечает и валидно' do
    it { should respond_to(:title) }
    it { should respond_to(:content) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }
    it { should respond_to(:category_id) }
    it { should respond_to(:comments_count) }
    it { should respond_to(:tag_list) }
    it { should respond_to(:employee_id) }
    it { should respond_to(:published_at) }
    it { should respond_to(:author_ids) }

    it { should respond_to(:clip) }

    it { should respond_to(:publish_persons) }
    it { should respond_to(:persons) }
    it { should respond_to(:publish_teams) }
    it { should respond_to(:teams) }

    it { should respond_to(:photo_video) }
    it { should respond_to(:main_image) }
    it { should respond_to(:authors) }
    it { should respond_to(:category) }
    it { should respond_to(:employee) }
    it { should respond_to(:comments) }
    it { should respond_to(:authors_publications) }
    it { should respond_to(:feed) }

    it { should have_one(:photo_video) }
    it { should have_one(:main_image) }
    it { should have_one(:clip) }

    it { should accept_nested_attributes_for :main_image }
    it { should accept_nested_attributes_for :clip }
    it { should accept_nested_attributes_for :authors }

    it { should belong_to(:category) }
    it { should belong_to(:employee) }

    it { should have_many(:publish_persons) }
    it { should have_many(:persons) }
    it { should have_many(:publish_teams) }
    it { should have_many(:teams) }

    it { should have_many(:comments) }
    it { should have_many(:authors_publications) }
    it { should have_many(:authors) }
    it { should have_one(:feed) }

    it { should respond_to(:seo) }

    it { should be_valid }
  end
end
