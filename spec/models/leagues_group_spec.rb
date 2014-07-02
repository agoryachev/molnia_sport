# encoding: utf-8
# == Schema Information
#
# Table name: leagues_groups # Группы в рамках лиги, группы
#
#  id         :integer          not null, primary key
#  title      :string(255)      default(""), not null # Название группы
#  date_at    :date                                   # Дата старта игр в рамках группы
#  league_id  :integer          not null              # Внешний ключ для связи с таблицей лиг
#  year_id    :integer                                # Внешний ключ для связи с годами
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe LeaguesGroup do
  let(:leagues_group) { FactoryGirl.create(:leagues_group) }

  subject { leagues_group }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:date_at) }
    it { should respond_to(:league_id) }
    it { should respond_to(:year_id) }

    it { should respond_to(:league) }
    it { should respond_to(:year) }
    it { should respond_to(:matches) }
    it { should respond_to(:leagues_statistics) }

    it { should belong_to(:league) }
    it { should belong_to(:year) }

    it { should have_many(:matches) }
    it { should accept_nested_attributes_for :matches }
    it { should have_many(:leagues_statistics) }

    it { should be_valid }
  end
end