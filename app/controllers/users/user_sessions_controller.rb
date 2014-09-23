# encoding: utf-8
class UserSessionsController < ApplicationController
  before_filter :redirect_logged_in, :only => [:new, :create]

  # GET /user_sessions/new
  # GET /user_sessions/new.json
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.json
  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save
        format.html { redirect_back_or_default(dashboard_url) }
        format.json { render json: @user_session, status: :created, location: @user_session }
      else
        flash[:error] = @user_session.errors.full_messages # собираем ошибки
        format.html { redirect_to :login }
        format.json { render json: @user_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.json
  def destroy
    @user_session = UserSession.find

    if @user_session
      @user_session.destroy

      respond_to do |format|
        format.html { redirect_to login_path }
        #format.json { head :ok }
      end
    else
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end
end
