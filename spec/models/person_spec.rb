# encoding: utf-8
# == Schema Information
#
# Table name: persons # Персоналии (игрок, тренер, владелец клуба и т.п.)
#
#  id                  :integer          not null, primary key
#  name_first          :string(255)      default(""), not null    # Имя
#  name_last           :string(255)      default(""), not null    # Фамилия
#  name_v              :string(255)                               # Отчество
#  content             :text             default(""), not null    # Описание
#  instagram           :string(255)                               # Ссылка на instagram
#  twitter             :string(255)                               # Ссылка на twitter
#  character_id        :integer                                   # Связь с таблицей character
#  number              :integer                                   # Номер игрока
#  height              :integer                                   # Рост
#  weight              :integer                                   # Вес
#  birthday            :date                                      # Дата рождения
#  citizenship         :string(255)                               # Гражданство
#  cost                :string(255)                               # Трансферная стоимость
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Person do
  let(:person) { FactoryGirl.build(:person) }

  subject { person }

  context 'отвечает и валидно' do 
    it { should respond_to(:name_first) }
    it { should respond_to(:name_last) }
    it { should respond_to(:name_v) }
    it { should respond_to(:content) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }
    it { should respond_to(:twitter) }
    it { should respond_to(:instagram) }
    it { should respond_to(:character_id) }
    it { should respond_to(:number) }
    it { should respond_to(:height) }
    it { should respond_to(:weight) }
    it { should respond_to(:birthday) }
    it { should respond_to(:citizenship) }
    it { should respond_to(:cost) }

    it { should respond_to(:character) }
    it { should respond_to(:teams_persons) }
    it { should respond_to(:teams) }
    it { should respond_to(:transfers) }
    it { should respond_to(:main_image) }

    it { should belong_to(:character) }

    it { should have_many(:teams_persons) }
    it { should have_many(:teams) }
    it { should have_many(:transfers) }

    it { should have_one(:main_image) }

    it { should accept_nested_attributes_for :main_image }

    it { should be_valid }
  end
end
