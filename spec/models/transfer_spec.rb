# encoding: utf-8
# == Schema Information
#
# Table name: transfers # Трансферы - переходы игроков
#
#  id                  :integer          not null, primary key
#  person_id           :integer          not null                 # Внешний ключ для связи с персоной
#  team_from_id        :integer                                   # Внешний ключ для связи с командой, которую игрок покидает
#  team_to_id          :integer                                   # Внешний ключ для связи с командой, в которую игрок приходит
#  content             :text                                      # Описание трансфера
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  state               :integer          default(0), not null     # Статус трансфера: 0 - начавшийся трансфер, 1 - завершившийся трансфер
#  start_at            :datetime                                  # Дата и время начала трансфера
#  finish_at           :datetime                                  # Дата и время завершения трансфера
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Transfer do
  let(:transfer) { FactoryGirl.create(:transfer) }

  subject { transfer }

  context 'отвечает и валидно' do 

    it { should respond_to(:person_id) }
    it { should respond_to(:team_from_id) }
    it { should respond_to(:team_to_id) }
    it { should respond_to(:state) }
    it { should respond_to(:start_at) }
    it { should respond_to(:finish_at) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_comments_enabled) }
    it { should respond_to(:content) }

    it { should respond_to(:person) }
    it { should respond_to(:team_from) }
    it { should respond_to(:team_to) }

    it { should belong_to(:person) }
    it { should belong_to(:team_from) }
    it { should belong_to(:team_to) }
    
    it { should be_valid }
  end
end