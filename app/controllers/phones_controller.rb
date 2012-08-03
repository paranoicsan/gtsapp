# encoding: utf-8
class PhonesController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :get_branch

  # GET /phones
  # GET /phones.json
  def index
    @phones = Phone.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @phones }
    end
  end

  # GET /phones/1
  # GET /phones/1.json
  def show
    @phone = find_phone params[:id]
    @branch = @phone.branch

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @phone }
    end
  end

  # GET /phones/new
  # GET /phones/new.json
  def new
    @phone = Phone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @phone }
    end
  end

  # GET /phones/1/edit
  def edit
    @phone = Phone.find(params[:id])
  end

  # POST /phones
  # POST /phones.json
  def create
    params[:phone][:branch_id] = params[:branch_id]
    @phone = Phone.new(params[:phone])

    respond_to do |format|
      if @phone.save
        format.html { redirect_to @phone, notice: 'Телефон создан.' }
        format.json { render json: @phone, status: :created, location: @phone }
      else
        format.html { render action: "new" }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /phones/1
  # PUT /phones/1.json
  def update
    @phone = find_phone params[:id]
    @branch = @phone.branch

    respond_to do |format|
      if @phone.update_attributes(params[:phone])
        format.html { redirect_to @branch, notice: 'Телефон изменён.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phones/1
  # DELETE /phones/1.json
  def destroy
    @phone = Phone.find(params[:id])
    branch_id = @phone.branch_id
    @phone.destroy

    respond_to do |format|
      format.html { redirect_to branch_url branch_id }
      format.json { head :ok }
    end
  end

  private
  # Определяет связанный филиал
  def get_branch
    @branch = Branch.find(params[:branch_id]) if params[:branch_id]
  end

  # Ищет телефон по укаазнному параметру
  # @param [Integer] id ключ объекта
  # @return [Phone] объект телефона
  def find_phone(id)
    Phone.find(id)
  end
end
