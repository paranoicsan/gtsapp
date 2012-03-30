# encoding: utf-8
require "rspec"
include ApplicationHelper

describe UsersController do

  def user_params
    pwd = "1111"
    {
        :username => "username",
        :password => pwd,
        :email => "test@test.com",
        :password_confirmation => pwd
    }
  end

  before(:each) do
    controller.stub(:require_user).and_return(true)
    controller.stub(:require_admin).and_return(true)
  end
  
  
  describe "POST create" do
    it "должен создать пользователя с указанной ролью" do
      params = user_params
      params[:roles] = %W(admin)
      expect {
        post :create, :user => params
      }.to change(User, :count).by(1), "Пользователь не создался"
      user = User.find_by_username(params[:username])
      puts user.inspect
      #noinspection RubyResolve
      assert user && user.is_admin? == true, "Роль не назначена"
    end
    
    #describe "with valid params" do
    #  it "creates a new movie" do
    #    expect {
    #      post :create, :movie => tmp_params
    #    }.to change(Movie, :count).by(1)
    #  end
    #
    #  it "assigns a newly created movie as @movie" do
    #    post :create, :movie => tmp_params
    #    assigns(:movie).should be_a(Movie)
    #    assigns(:movie).should be_persisted
    #  end
    #
    #  it "redirects to the homepage" do
    #    post :create, :movie => tmp_params
    #    response.should redirect_to(movies_path)
    #  end
    #end
  end

end