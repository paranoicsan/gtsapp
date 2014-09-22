# encoding: utf-8
class PhonesController < ApplicationController

  helper :application

  before_filter :require_user,
                :assign_branch

  # GET /phones
  def index
    @phones = Phone.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /phones/1
  def show
    @phone = find_phone params[:id]
    @branch = @phone.branch

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /branches/:branch_id/phones/new
  def new
    order = @branch.next_phone_order_index
    @phone = @branch.phones.new order_num: order
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /phones/1/edit
  def edit
    @phone = Phone.find(params[:id])
  end

  # POST /phones
  def create
    params[:phone][:branch_id] = params[:branch_id]
    @phone = Phone.new(params[:phone])
    @branch = Branch.find @phone.branch_id

    respond_to do |format|
      if @phone.save
        log_operation :phone, :create, @branch.company.id
        @phone.branch.update_phone_order true
        format.html { redirect_to @branch, notice: 'Телефон создан.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /phones/1
  def update
    @phone = find_phone params[:id]
    @branch = Branch.find @phone.branch_id

    respond_to do |format|
      if @phone.update_attributes(params[:phone])
        @phone.branch.update_phone_order
        log_operation :phone, :update, @branch.company.id
        format.html { redirect_to @branch, notice: 'Телефон изменён.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /phones/1
  def destroy
    @phone = Phone.find(params[:id])
    @branch = Branch.find @phone.branch_id
    log_operation :phone, :destroy, @branch.company.id
    @phone.destroy
    @phone.branch.update_phone_order

    respond_to do |format|
      format.html { redirect_to branch_url @branch }
    end
  end

  private

  ##
  # Определяет связанный филиал
  #
  def assign_branch
    @branch = Branch.find(params[:branch_id]) if params[:branch_id]
  end

  # Ищет телефон по укаазнному параметру
  #
  # @param [Integer] id ключ объекта
  # @return [Phone] объект телефона
  #
  def find_phone(id)
    Phone.find(id)
  end
end
