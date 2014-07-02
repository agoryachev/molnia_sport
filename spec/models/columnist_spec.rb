# encoding: utf-8
# == Schema Information
#
# Table name: columnists # Колумнисты
#
#  id           :integer          not null, primary key
#  name_first   :string(255)                            # Имя
#  name_last    :string(255)                            # Фамилия
#  name_v       :string(255)                            # Отчество
#  content      :text                                   # Описание
#  is_published :boolean          default(FALSE)        # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted   :boolean          default(FALSE)        # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Columnist do
  let(:columnist) { FactoryGirl.build(:columnist) }

  subject { columnist }

  context 'отвечает и валидно' do
    it { should respond_to(:name_first) }
    it { should respond_to(:name_last) }
    it { should respond_to(:name_v) }
    it { should respond_to(:content) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }

    it { should respond_to(:main_image) }

    it { should have_one(:main_image) }

    it { should accept_nested_attributes_for :main_image }

    it { should respond_to(:seo) }

    it { should be_valid }
  end
end
