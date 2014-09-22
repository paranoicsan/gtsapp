# Encoding: utf-8
class UsersController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_admin

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    # проверяем, была ли передана роль через параметры
    if params[:user]['roles'].is_a?(String)
      params[:user]['roles'] = [params[:user]['roles']]
    end

    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Пользователь создан' }
        format.json { render json: users_path, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    params[:user][:roles] = [params[:user][:roles]]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      message = nil
      @user = User.find(params[:id])
      @user.destroy
    rescue
      message = %Q{Пользователь не может быть удалён. Возможно, он связан с какой-либо компанией.}
    end

    # определяем сообщение
    params = message ? { error: message } : {}

    respond_to do |format|
      format.html { redirect_to users_url, flash: params }
      format.json { head :ok }
    end
  end
end
