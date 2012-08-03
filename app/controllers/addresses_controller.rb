# encoding: utf-8
class AddressesController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :get_branch

  # Ищет адрес по укаазнному параметру
  # @param [Integer] id ключ адреса
  # @return [Address] объект адреса
  def find_address(id)
    Address.find(id)
  end

  def index
    @addresses = Address.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @addresses }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    @address = find_address params[:id]
    @branch = @address.branch

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @address }
    end
  end

  # GET /addresses/new
  # GET /addresses/new.json
  def new
    @address = Address.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @address }
    end
  end

  # GET /addresses/1/edit
  def edit
    @address = find_address params[:id]
  end

  # POST /addresses
  # POST /addresses.json
  def create
    params[:address][:branch_id] = params[:branch_id]
    @address = Address.new(params[:address])

    respond_to do |format|
      if @address.save
        format.html { redirect_to @branch, notice: 'Адрес добавлен.' }
        format.json { render json: @address, status: :created, location: @address }
      else
        format.html { render action: "new" }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.json
  def update
    @address = find_address params[:id]
    @branch = @address.branch

    respond_to do |format|
      if @address.update_attributes(params[:address])
        format.html { redirect_to @branch, notice: 'Адрес изменён.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address = find_address params[:id]
    branch_id = @address.branch_id

    @address.destroy

    respond_to do |format|
      #noinspection RubyResolve
      format.html { redirect_to branch_url branch_id }
      format.json { head :ok }
    end
  end

  private
  # Определяет связанный филиал
  def get_branch
    @branch = Branch.find(params[:branch_id]) if params[:branch_id]
  end
end
