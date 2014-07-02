# encoding: utf-8
# == Schema Information
#
# Table name: pages # Страницы сайта
#
#  id                  :integer          not null, primary key
#  title               :string(255)      default(""), not null    # Заголовок страницы
#  content             :text             default(""), not null    # Содержимое страницы
#  is_published        :boolean          default(TRUE)            # 1 - страница доступна для просмотра, 0 - страница не доступна для просмотра
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.build(:page) }

  subject { page }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:content) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }

    it { should respond_to(:comments) }
    it { should respond_to(:authors_publications) }
    it { should respond_to(:authors) }

    it { should have_many(:comments) }
    it { should have_many(:authors_publications) }
    it { should have_many(:authors) }

    it { should respond_to(:seo) }

    it { should be_valid }
  end
end