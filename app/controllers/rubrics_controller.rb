#Encoding: utf-8
class RubricsController < ApplicationController

  helper :application

  before_filter :require_user,
                :require_admin

  # GET /rubrics
  def index
    @rubrics = Rubric.order('name')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /rubrics/new
  def new
    @rubric = Rubric.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /rubrics/1/edit
  def edit
    @rubric = Rubric.find(params[:id])
  end

  # POST /rubrics
  def create
    @rubric = Rubric.new(params[:rubric])

    respond_to do |format|
      if @rubric.save
        format.html { redirect_to rubrics_path, notice: 'Rubric was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /rubrics/1
  def update
    @rubric = Rubric.find(params[:id])

    respond_to do |format|
      if @rubric.update_attributes(params[:rubric])
        format.html { redirect_to rubrics_path, notice: 'Rubric was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /rubrics/1
  def destroy
    begin
      message = nil
      @rubric = Rubric.find(params[:id])
      @rubric.destroy
    rescue
      message = 'Рубрика используется в одной из компаний или в продукте.'
    end

    # определяем сообщение
    params = message ? { error: message } : {}
    respond_to do |format|
      format.html { redirect_to rubrics_url, flash: params }
    end
  end
end
