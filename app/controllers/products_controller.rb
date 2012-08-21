# Encoding: utf-8
class ProductsController < ApplicationController
  helper :application
  before_filter :get_contract
  before_filter :require_user
  before_filter :require_system_users, only: [:new, :create, :edit, :update, :destroy]
  autocomplete :rubric, :name

  def good_response
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

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
    @product.destroy

    respond_to do |format|
      format.html { redirect_to contract_url(contract_id) }
      format.json { head :ok }
    end
  end

private
  def get_contract
    @contract = Contract.find(params[:contract_id]) if params[:contract_id]
    if params[:product]
      params[:product][:rubric_id] = params[:product_rubric_id] if params[:product_rubric_id]
    end
  end
end
