# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: counter_media_publications # Промежуточная таблица для связи файлов медиа библиотеки с публикациями (новости, блоги и т.д.)
#
#  id               :integer          not null, primary key
#  publication_type :string(255)      not null              # Тип публикации(Post, MediaFile)
#  publication_id   :integer          not null              # Внешний ключ для связи с опубликованным материалом (Post, BlogPost)
#  media_file_id    :integer          not null              # Внешний ключ для связи с медиабиблиотекой
#

require 'spec_helper'

describe CounterMediaPublication do
  let(:counter_media_publication) { FactoryGirl.create(:counter_media_publication) }

  subject { counter_media_publication }

  context 'отвечает и валидно' do 
    it { should respond_to(:publication_type) }
    it { should respond_to(:publication_id) }
    it { should respond_to(:media_file_id) }

    it { should respond_to(:media_file) }
    it { should respond_to(:publication) }

    it { should belong_to(:media_file) }
    it { should belong_to(:publication) }
   
    it { should be_valid }
  end
end