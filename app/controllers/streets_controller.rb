#Encoding: utf-8
class StreetsController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_system_users, :only => [:new, :edit, :update, :create, :destroy]

  # GET /streets
  # GET /streets.json
  def index
    @streets = Street.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @streets }
    end
  end

  # GET /streets/new
  # GET /streets/new.json
  def new
    @street = Street.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @street }
    end
  end

  # GET /streets/1/edit
  def edit
    @street = Street.find(params[:id])
  end

  # POST /streets
  # POST /streets.json
  def create
    @street = Street.new(params[:street])

    respond_to do |format|
      if @street.save
        format.html { redirect_to streets_path, notice: 'Street was successfully created.' }
        format.json { render json: @streets, status: :created, location: @street }
      else
        format.html { render action: "new" }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /streets/1
  # PUT /streets/1.json
  def update
    @street = Street.find(params[:id])

    respond_to do |format|
      if @street.update_attributes(params[:street])
        format.html { redirect_to streets_path, notice: 'Street was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streets/1
  # DELETE /streets/1.json
  def destroy

    begin
      message = nil
      @street = Street.find(params[:id])
      @street.destroy
    rescue
      message = %Q{Улица не может быть удалена. Она используется по крайней мере одним филиалом.}
    end

    # определяем сообщение
    params = message ? { error: message } : {}

    respond_to do |format|
      format.html { redirect_to streets_url, flash: params }
      format.json { head :ok }
    end

  end

  ##
  # POST streets_by_city
  def streets_by_city
    @streets_by_city = []
    if params[:city_id]
      @streets_by_city = Street.where('city_id = ?', params[:city_id]).order("name").paginate(:page => params[:page], :per_page => 100)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
end
