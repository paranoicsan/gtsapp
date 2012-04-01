# encoding: utf-8
require 'rspec'
require 'shared/auth_helper'

describe UsersController do

  RSpec.configure do |c|
    c.include AuthHelper
  end

  before(:each) do
    controller.stub(:require_user).and_return(true)
    controller.stub(:require_admin).and_return(true)
    @user = mock(User)
  end
  
  describe "POST create" do
    it "должен создать пользователя с указанной ролью" do
      params = user_params "admin"
      params_str = {} # хэш, у которого все ключи - строки
      params.each { |k, v| params_str[k.to_s] = v }
      User.should_receive(:new).with(params_str).and_return(@user)
      @user.should_receive(:save).with(no_args)
      post :create, :user => params
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