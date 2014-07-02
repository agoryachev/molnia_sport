# encoding: utf-8
# == Schema Information
#
# Table name: comments # Комментарии пользователей
#
#  id               :integer          not null, primary key
#  title            :string(50)       default(""), not null    # Заголовок комментария
#  content          :text             default(""), not null    # Тело комментария
#  commentable_id   :integer          not null                 # Внешний ключ для комментируемого материала
#  commentable_type :string(255)      not null                 # Внешний ключ для комментируемого материала
#  user_id          :integer          not null                 # Внешний ключ для связи с таблицей frontend-пользователей user
#  is_published     :boolean          default(FALSE)           # 1 - комментарий доступен для просмотра, 0 - комментарий скрыт
#  is_deleted       :boolean          default(FALSE), not null # 1 - комментарий удален (фактически скрыт без возможности отображения), 0 - обычный комментарий
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# require 'spec_helper'

# describe Comment do
#   let(:comment) { FactoryGirl.create(:comment) }

#   subject { comment }

#   context 'отвечает и валидно' do 
#     it { should respond_to(:title) }
#     it { should respond_to(:content) }
#     it { should respond_to(:is_published) }
#     it { should respond_to(:is_deleted) }

#     it { should belong_to(:commentable) }
#     it { should belong_to(:user) }
   
#     it { should be_valid }
#   end
# end