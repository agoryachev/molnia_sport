# encoding: utf-8
require 'spec_helper'

describe Backend::AuthorsController do

  let(:author) do
    author = FactoryGirl.create(:author)
  end

  before :all do
    Author.destroy_all
  end
  
  after(:each) do
    DatabaseCleaner.clean
  end

  #describe '#index' do
  #  it "успешно отвечает с HTTP кодом 200 и рендерит шаблон index" do
  #    get :index
  #    response.should be_success
  #    response.code.should eq('200')
  #    response.should render_template('index')
  #  end
  #end

  # describe '#index xhr' do
  #   it "успешно отвечает с HTTP кодом 200 и рендерит шаблон index" do
  #     xhr :get, :index, search: "поисковая фраза"
  #     response.should be_success
  #     response.code.should eq('200')
  #     response.should render_template('index')
  #   end
  # end

  # describe '#new' do
  #   it "успешно отвечает с HTTP кодом 200" do        
  #     get :new
  #     response.should be_success
  #     response.code.should eq('200')
  #   end

  #   it "рендерит шаблон new" do
  #     get :new
  #     response.should render_template('new')
  #   end
  # end

  # describe '#create' do
  #   let(:new_author) { FactoryGirl.attributes_for(:author) }

  #   context 'если успешно,' do
  #     it 'изменяет счетчик' do
  #       expect {
  #         post :create, author: new_author
  #       }.to change(Author, :count).by(1)
  #     end

  #     it 'редиректит на страницу редактирования' do
  #       post :create, author: new_author
  #       flash[:notice].should == I18n.t("msg.saved")
  #       response.should redirect_to(edit_backend_author_url(Author.last))
  #     end

  #     it 'редиректит на index, если кликнули save_and_exit' do
  #       post :create, author: new_author, commit: I18n.t("label.save_and_exit")
  #       flash[:notice].should == I18n.t("msg.saved")
  #       response.should redirect_to(backend_authors_url)
  #     end
  #   end

  #   context 'если не успешно,' do
  #     before :each do
  #       new_author[:name] = nil
  #     end

  #     it 'не изменяет счетчик' do
  #       expect {
  #         post :create, author: new_author
  #       }.to change(Author, :count).by(0)
  #     end

  #     it 'выдает сообщение о неудачном сохранении и рендерит шаблон new' do
  #       post :create, author: new_author
  #       flash[:error].should == I18n.t("msg.save_error")
  #       response.should render_template('new')
  #     end
  #   end
  # end

  # describe '#edit' do
  #   it "успешно отвечает с HTTP кодом 200" do        
  #     get :edit, id: author
  #     response.should be_success
  #     response.code.should eq('200')
  #   end

  #   it "рендерит шаблон edit" do
  #     get :edit, id: author
  #     response.should render_template('edit')
  #   end

  #   it "вызывает исключение RecordNotFound при ошибочном id" do 
  #     expect{ get :edit, id: 999997
  #       }.to raise_error(ActiveRecord::RecordNotFound)
  #   end
  # end

  # describe '#update' do
  #   let(:author_attributes) { FactoryGirl.attributes_for(:author) }

  #   context 'если успешно,' do
  #     context 'когда обычный запрос,' do  
  #       it 'редиректит на страницу редактирования' do
  #         put :update, id: author, author: author_attributes
  #         flash[:notice].should == I18n.t("msg.saved")
  #         response.should redirect_to(edit_backend_author_url(Author.last))
  #       end

  #       it 'редиректит на index, если кликнули save_and_exit' do
  #         post :update, id: author, author: author_attributes, commit: I18n.t("label.save_and_exit")
  #         flash[:notice].should == I18n.t("msg.saved")
  #         response.should redirect_to(backend_authors_url)
  #       end

  #       context 'когда передано employee_id,' do
  #         let(:emploee) { FactoryGirl.create(:employee) }

  #         before :each do
  #           author_attributes[:employee_id] = emploee.id
  #         end

  #         it 'редиректит на страницу редактирования' do
  #           put :update, id: author, author: author_attributes
  #           flash[:notice].should == I18n.t("msg.saved")
  #           response.should redirect_to(edit_backend_author_url(Author.last))
  #         end
  #       end
  #     end
  #   end

  #   context 'если неуспешно,' do
  #     before :each do
  #       author_attributes[:name] = ''
  #     end

  #     context 'когда обычный запрос,' do
  #       it 'рендерит страницу edit' do
  #         put :update, id: author, author: author_attributes
  #         flash[:error].should == I18n.t("msg.save_error")
  #         response.should render_template('edit')
  #       end
  #     end
  #   end

  #   it "вызывает исключение RecordNotFound при ошибочном id" do 
  #     expect{ put :update, id: 99997
  #       }.to raise_error(ActiveRecord::RecordNotFound)
  #   end
  # end

  # describe '#destroy' do
  #   it 'изменяет счетчик' do
  #     author
  #     expect {
  #       delete :destroy, id: author
  #     }.to change(Author, :count).by(-1)
  #   end

  #   it 'перенаправление на индексную страницу' do
  #     delete :destroy, id: author
  #     flash[:notice].should == I18n.t("msg.deleted")
  #     response.should redirect_to(backend_authors_url)
  #   end

  #   it "вызывает исключение RecordNotFound при ошибочном id" do 
  #     expect{ delete :destroy, id: 99997
  #       }.to raise_error(ActiveRecord::RecordNotFound)
  #   end
  # end

  # describe '#sort' do
  #   context 'если AJAX запрос,' do
  #     it "успешно отвечает с HTTP кодом 200 и рендерит пустой шаблон" do
  #       xhr :post, :sort, authors_publication: Author.all.map(&:id)
  #       response.should be_success
  #       response.code.should eq('200')
  #       response.body.should be_blank
  #     end
  #   end
  # end

end