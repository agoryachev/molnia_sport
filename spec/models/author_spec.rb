# encoding: utf-8
# == Schema Information
#
# Table name: authors # Авторы статей (могут быть связанны с сотрудниками по полю employee_id)
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null              # Имя автора(или псевдоним)
#  employee_id     :integer                                # Идентификатор сотрудника, аккаунта автора в системе администрирования
#  posts_count     :integer          default(0), not null  # Количество новостей, принадлежащих автору
#  videos_count    :integer          default(0), not null  # Количество видео-сюжетов, принадлежащих автору
#  galleries_count :integer          default(0), not null  # Количество фотогалерей, принадлежащих автору
#  media_count     :integer          default(0), not null  # Количество файлов в медиабиблиотеке, принадлежащих автору
#

require 'spec_helper'

describe Author do
  let(:author) { FactoryGirl.create(:author) }

  subject { author }

  context 'отвечает и валидно' do 
    it { should respond_to(:name) }
    it { should respond_to(:posts_count) }
    it { should respond_to(:videos_count) }
    it { should respond_to(:galleries_count) }
    it { should respond_to(:media_count) }

    it { should respond_to(:employee) }
    it { should respond_to(:authors_publications) }
    it { should respond_to(:media) }
    it { should respond_to(:posts) }

    it { should belong_to(:employee) }
    
    it { should have_many(:authors_publications) }
    it { should have_many(:media) }
    it { should have_many(:posts) }
    
    it { should be_valid }
  end
end