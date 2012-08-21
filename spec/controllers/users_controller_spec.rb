# encoding: utf-8
require 'rspec'
#require 'shared/auth_helper'

describe UsersController do

  before(:each) do
    make_user_admin
  end

  let(:user) { FactoryGirl.create :user }
  
  describe "POST create" do

    def post_valid
      params = FactoryGirl.attributes_for :user
      post :create, :user => params
    end

    it "создаёт нового пользователя" do
      expect {
        post_valid
      }.to change(User, :count).by(1)
    end
  end

  describe "DELETE destroy" do

    def del
      user
      delete :destroy, :id => user.to_param
    end

    it "удаляет указанного пользователя" do
      user
      expect {
        del
      }.to change(User, :count).by(-1)
    end

    it "направляет на список пользователей" do
      del
      #noinspection RubyResolve
      response.should redirect_to(users_path)
    end

    it "показывает ошибку при удалении пользователя, связанного с объектами" do
      s = %Q{Пользователь не может быть удалён. Возможно, он связан с какой-либо компанией.}
      FactoryGirl.create :company, editor: user
      del
      flash[:error].should eq(s)
    end
  end

end