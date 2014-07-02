# encoding: utf-8
# == Schema Information
#
# Table name: authors_publications # Связующая таблица авторов с публикациями (Галерея, Видео, Новость)
#
#  id              :integer          not null, primary key
#  author_id       :integer          not null              # Внешний ключ для связи с автором
#  authorable_type :string(255)      not null              # Тип связанной публикации (Post, Video, Gallery)
#  authorable_id   :integer          not null              # Внешний ключ для связи с публикацией (Post, Video, Gallery)
#

require 'spec_helper'

describe Author do
  let(:authors_publication) { FactoryGirl.create(:authors_publication) }

  subject { authors_publication }

  context 'отвечает и валидно' do 
    it { should respond_to(:author) }
    it { should respond_to(:authorable) }

    it { should belong_to(:author) }
    it { should belong_to(:authorable) }
    
    it { should be_valid }
  end
end