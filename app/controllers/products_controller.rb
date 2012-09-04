# Encoding: utf-8
class ProductsController < ApplicationController
  helper :application
  before_filter :get_contract
  before_filter :require_user
  before_filter :require_system_users, only: [:new, :create, :edit, :update, :destroy]
  autocomplete :rubric, :name

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @contract = @product.contract

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    params[:product][:contract_id] = params[:contract_id]
    @product = Product.new(params[:product])

    #@contract = @product.contract

    respond_to do |format|
      if @product.save
        log_operation :create
        format.html { redirect_to @contract, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    @contract = @product.contract

    respond_to do |format|
      if @product.update_attributes(params[:product])
        log_operation :update
        format.html { redirect_to @contract, notice: 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    contract_id = @product.contract_id

    @contract = Contract.find contract_id
    log_operation :destroy

    @product.destroy

    respond_to do |format|
      format.html { redirect_to contract_url(contract_id) }
      format.json { head :ok }
    end
  end

  ##
  # Переопределяем метод, возвращающий элементы автозаполнения
  # для ограничивания выборки
  def get_autocomplete_items(parameters)
    items = super(parameters)
    if @contract
      ids = []
      @contract.company.rubrics.each { |r| ids << r.id }
      items.where(:id => ids)
    end
  end

  private
  ##
  # Пишет историю компании
  def log_operation(operation)
    case operation
      when :create
        s = "Продукт создан"
      when :update
        s = "Продукт изменён"
      when :destroy
        s = "Продукт удалён"
      else
        s = "Неизвестная операция"
    end
    CompanyHistory.log(s, current_user.username, @contract.company.id)
  end

  def get_contract
    @contract = Contract.find(params[:contract_id]) if params[:contract_id]
    if params[:product]
      params[:product][:rubric_id] = params[:product_rubric_id] if params[:product_rubric_id]
    end
  end
end
