# encoding: utf-8
# == Schema Information
#
# Table name: feedbacks # Отзывы/пожелания пользователей
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null                 # Внешний ключ для связи с таблицей frontend-пользователей user
#  title      :string(255)      not null                 # Заголовок сообщения
#  content    :text             default(""), not null    # Содержимое сообщения
#  is_replied :boolean          default(FALSE), not null # 0 - на сообщение не был дан ответ, 1 - ответ был отправлен посетителю
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Feedback do
  let(:feedback) { FactoryGirl.create(:feedback) }

  subject { feedback }

  context 'отвечает и валидно' do 
    it { should respond_to(:title) }
    it { should respond_to(:content) }
    it { should respond_to(:is_replied) }
    it { should respond_to(:user) }

    it { should belong_to(:user) }
   
    it { should be_valid }
  end
end