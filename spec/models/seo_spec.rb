# encoding: utf-8
# == Schema Information
#
# Table name: seos # SEO-информация
#
#  id           :integer          not null, primary key
#  seoable_id   :integer          not null              # Внешний ключ для материала, снабжаемого SEO-параметрами
#  seoable_type :string(255)      not null              # Внешний ключ для материала, снабжаемого SEO-параметрами
#  slug         :string(255)      default(""), not null # ЧПУ - человекопонятный урл
#  keywords     :string(255)      default(""), not null # Ключевые слова для META-тэга keywords
#  description  :string(255)      default(""), not null # Описание для META-тэга description
#

require 'spec_helper'

describe Seo do
  let(:seo) { FactoryGirl.create(:seo) }

  subject { seo }

  context 'отвечает и валидно' do 
    it { should respond_to(:slug) }
    it { should respond_to(:keywords) }
    it { should respond_to(:description) }
    
    it { should respond_to(:seoable) }
    
    it { should be_valid }
  end
end
