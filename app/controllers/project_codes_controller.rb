# encoding: utf-8
class ProjectCodesController < ApplicationController
  helper :application

  before_filter :require_user
  before_filter :require_admin

  # GET /project_codes
  # GET /project_codes.json
  def index
    @project_codes = Code.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_codes }
    end
  end

  # GET /project_codes/new
  # GET /project_codes/new.json
  def new
    @project_code = Code.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_code }
    end
  end

  # GET /project_codes/1/edit
  def edit
    @project_code = Code.find(params[:id])
  end

  # POST /project_codes
  # POST /project_codes.json
  def create
    @project_code = Code.new(params[:project_code])

    respond_to do |format|
      if @project_code.save
        format.html { redirect_to project_codes_path, notice: 'Код проекта создан.' }
        format.json { render json: @project_codes, status: :created, location: @project_code }
      else
        format.html { render action: "new" }
        format.json { render json: @project_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_codes/1
  # PUT /project_codes/1.json
  def update
    @project_code = Code.find(params[:id])

    respond_to do |format|
      if @project_code.update_attributes(params[:project_code])
        format.html { redirect_to project_codes_path, notice: 'Код проекта обновлён.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_codes/1
  # DELETE /project_codes/1.json
  def destroy
    @project_code = Code.find(params[:id])
    @project_code.destroy

    respond_to do |format|
      format.html { redirect_to project_codes_url }
      format.json { head :ok }
    end
  end
end
