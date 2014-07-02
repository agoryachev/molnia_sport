# encoding: utf-8
# == Schema Information
#
# Table name: teams # Команды (в рамках групповых видов спорта)
#
#  id                  :integer          not null, primary key
#  title               :string(255)      default(""), not null    # Название команды
#  subtitle            :string(255)                               # Подзаголовок
#  content             :text             default(""), not null    # Описание команды
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  country_id          :integer                                   # Связь со странами
#  category_id         :integer          not null                 # Внешний ключ для связи с категорией
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe Team do
  let(:team) { FactoryGirl.create(:team) }

  subject { team }

  context 'отвечает и валидно' do 
    it { should respond_to(:person_ids) }
    it { should respond_to(:category_id) }
    it { should respond_to(:country_id) }

    it { should respond_to(:title) }
    it { should respond_to(:subtitle) }
    it { should respond_to(:content) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }

    it { should respond_to(:category) }
    it { should respond_to(:country) }

    it { should respond_to(:main_image) }
    it { should respond_to(:teams_persons) }
    it { should respond_to(:persons) }
    it { should respond_to(:publish_teams) }
    it { should respond_to(:posts) }
    it { should respond_to(:galleries) }
    it { should respond_to(:videos) }
    it { should respond_to(:leagues_statistics) }

    it { should respond_to(:main_image) }

    it { should belong_to(:category) }
    it { should belong_to(:country) }

    it { should have_one(:main_image) }
    it { should have_many(:teams_persons) }
    it { should have_many(:persons) }
    it { should have_many(:publish_teams) }
    it { should have_many(:posts) }
    it { should have_many(:galleries) }
    it { should have_many(:videos) }
    it { should have_many(:leagues_statistics) }
    
    it { should accept_nested_attributes_for :main_image }

    it { should be_valid }
  end
end