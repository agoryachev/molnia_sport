# encoding: utf-8
# == Schema Information
#
# Table name: matches # Матчи
#
#  id                  :integer          not null, primary key
#  team_home_id        :integer                                   # Внешний ключ для связи с принимающей командой
#  team_guest_id       :integer                                   # Внешний ключ для связи с гостевой командой
#  leagues_group_id    :integer                                   # Связь с таблицей группы
#  referee_id          :integer                                   # Внешний ключ для судьи матча
#  title               :string(255)                               # Название матча
#  content             :text                                      # Описание матча
#  is_published        :boolean          default(TRUE)            # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  count_home          :integer                                   # Очки принимащей команды (сколько забили голов/шайб гостевой команде)
#  count_guest         :integer                                   # Очки гостевой команды (сколько забили голов/шайб принимающей команде)
#  date_at             :date             not null                 # Дата проведения матча
#  start_at            :time                                      # Время начала матча
#  finish_at           :time                                      # Время окончания матча
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Match do
  let(:match) { FactoryGirl.create(:match) }

  subject { match }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:content) }
    it { should respond_to(:count_home) }
    it { should respond_to(:count_guest) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }
    it { should respond_to(:leagues_group_id) }
    it { should respond_to(:team_home_id) }
    it { should respond_to(:team_guest_id) }
    it { should respond_to(:date_at) }
    it { should respond_to(:start_at) }
    it { should respond_to(:finish_at) }

    it { should respond_to(:team_home) }
    it { should respond_to(:team_guest) }
    it { should respond_to(:leagues_group) }
    
    it { should belong_to(:team_home) }
    it { should belong_to(:team_guest) }
    it { should belong_to(:leagues_group) }

    it { should be_valid }
  end
end
