# encoding: utf-8
# == Schema Information
#
# Table name: leagues # Лиги, чемпионаты
#
#  id                      :integer          not null, primary key
#  category_id             :integer                                   # Внешний ключ для связи с категорией
#  country_id              :integer          default(0)               # Внешний ключ для связи с странами
#  title                   :string(255)      default(""), not null    # Название лиги
#  content                 :text                                      # Описание лиги
#  is_published            :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted              :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled     :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  is_leagues_group_slider :boolean          default(FALSE)           # 1 - показывать в слайдере, 0 - нет
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'spec_helper'

describe League do
  let(:league) { FactoryGirl.create(:league) }

  subject { league }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:content) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }
    it { should respond_to(:category_id) }

    it { should respond_to(:leagues_group_ids) }
    it { should respond_to(:years) }
    it { should respond_to(:leagues_groups) }

    it { should respond_to(:category) }
    it { should respond_to(:country) }

    it { should belong_to(:category) }
    it { should belong_to(:country) }

    it { should have_many(:years) }
    it { should have_many(:leagues_groups) }

    it { should be_valid }
  end
end
