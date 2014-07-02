# encoding: utf-8
# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  title           :string(255)      default(""), not null    # Заголовок категории
#  is_published    :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  placement_index :integer          default(0), not null     # Поле для задания порядка следования категорий на одном уровне относительно друг друга
#  color           :string(255)      default("red_page")      # Гавный цвет категории
#

require 'spec_helper'

describe Category do
  let(:category) { FactoryGirl.create(:category) }

  subject { category }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:is_published) }
    it { should respond_to(:placement_index) }
    it { should respond_to(:color) }

    it { should respond_to(:posts) }
    it { should respond_to(:galleries) }
    it { should respond_to(:videos) }
    it { should respond_to(:teams) }
    it { should respond_to(:leagues) }
    it { should respond_to(:countries) }

    it { should have_many(:posts) }
    it { should have_many(:galleries) }
    it { should have_many(:videos) }
    it { should have_many(:teams) }
    it { should have_many(:leagues) }
    it { should have_and_belong_to_many(:countries) }
    
    it { should be_valid }
  end
end