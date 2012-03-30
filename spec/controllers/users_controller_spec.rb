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

  def create_user
    params = {}
    user_params.each { |k, v| params[k] = "t_#{v}" }
    unless User.find_by_username(params[:t_username])
      #puts params.inspect
      user = User.create!(params)
      #noinspection RubyResolve
      user.add_role "admin"
    end
  end

  before(:each) do
    create_user
    @app_controller = mock("ApplicationController")
    #@app_controller.stub(:current_user).and_return(User.first)
    #@app_controller.stub(:require_user).and_return(true)
    #@app_controller.stub(:require_admin).and_return(true)
    #@user_model = mock("User")
  end
  
  
  describe "POST create" do
    it "должен создать пользователя с указанной ролью" do
      params = user_params
      #roles = ["admin"]
      #params[:roles] = roles
      @app_controller.stub(:require_user).and_return(true)
      post :create, :user => params
      #noinspection RubyResolve
      puts flash.inspect
      response.should redirect_to(users_path)
      #expect {
      #  post :create, :user => params
      #}.to change(User, :count).by(1), "Пользователь не создался"
      #assert :user.roles == roles, "Роль не назначена"
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