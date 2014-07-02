# encoding: utf-8
# == Schema Information
#
# Table name: columnist_posts # Заметки колумнистов
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null                 # Заголовок заметки
#  subtitle            :string(255)                               # Подзаголовок заметки
#  content             :text             default(""), not null    # Содержимое заметки
#  category_id         :integer          not null                 # Внешний ключ для связи с таблицей разделов
#  employee_id         :integer          not null                 # Внешний ключ для связи с таблицей сотрудников
#  columnist_id        :integer          not null                 # Внешний ключ для связи с таблицей колумнистов
#  is_published        :boolean          default(FALSE), not null # 1 - опубликовано (отображается), 0 - не опубликовано (не отображается)
#  is_deleted          :boolean          default(FALSE), not null # 1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись
#  is_comments_enabled :boolean          default(TRUE), not null  # 1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии
#  delta               :boolean          default(TRUE), not null  # Индекс для полнотекстового поиска (Sphinx)
#  comments_count      :integer          default(0), not null     # Количество комментариев к новости
#  published_at        :datetime         not null                 # Дата и время публикации
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe ColumnistPost do
  let(:columnist_post) { FactoryGirl.create(:columnist_post) }

  subject { columnist_post }

  context 'отвечает и валидно' do
    it { should respond_to(:title) }
    it { should respond_to(:subtitle) }
    it { should respond_to(:content) }
    it { should respond_to(:category_id) }
    it { should respond_to(:employee_id) }
    it { should respond_to(:columnist_id) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_deleted) }
    it { should respond_to(:is_comments_enabled) }
    it { should respond_to(:delta) }
    it { should respond_to(:comments_count) }
    it { should respond_to(:published_at) }

    it { should respond_to(:category) }
    it { should respond_to(:employee) }
    it { should respond_to(:columnist) }
    it { should respond_to(:comments) }

    it { should belong_to(:category) }
    it { should belong_to(:employee) }
    it { should belong_to(:columnist) }

    it { should have_many(:comments) }

    it { should respond_to(:seo) }

    it { should be_valid }
  end
end
