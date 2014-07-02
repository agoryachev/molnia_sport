# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: gallery_files # Связующая таблица фотогалереи с медиабиблиотекой
#
#  id              :integer          not null, primary key
#  gallery_id      :integer          not null                 # Внешний ключ для связи с фотогалерей
#  description     :string(255)                               # Описание изображения
#  placement_index :integer          default(0), not null     # Поле для задания порядка следования изображений относительно друг друга
#  is_published    :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe GalleryFile do
  let(:gallery_file) { FactoryGirl.create(:gallery_file) }

  subject { gallery_file }

  context 'отвечает и валидно' do 
    it { should respond_to(:description) }
    it { should respond_to(:placement_index) }
    it { should respond_to(:is_published) }

    it { should respond_to(:gallery_image) }
    it { should respond_to(:gallery) }

    it { should have_one(:gallery_image) }
    it { should belong_to(:gallery) }

    it { should be_valid }
  end
end