#encoding: utf-8
class ProductTypesController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_admin

  # GET /product_types
  # GET /product_types.json
  def index
    @producttypes = ProductType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @producttypes }
    end
  end

  # GET /product_types/new
  # GET /product_types/new.json
  def new
    @producttype = ProductType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: product_types_url }
    end
  end

  # GET /product_types/1/edit
  def edit
    @producttype = ProductType.find(params[:id])
  end

  # POST /product_types
  # POST /product_types.json
  def create
    @producttype = ProductType.new(params[:producttype])

    respond_to do |format|
      if @producttype.save
        format.html { redirect_to product_types_url, notice: 'ProductType was successfully created.' }
        format.json { render json: product_types_url, status: :created, location: @producttype }
      else
        format.html { render action: "new" }
        format.json { render json: @producttype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_types/1
  # PUT /product_types/1.json
  def update
    @producttype = ProductType.find(params[:id])

    respond_to do |format|
      if @producttype.update_attributes(params[:producttype])
        format.html { redirect_to product_types_url, notice: 'ProductType was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @producttype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_types/1
  # DELETE /product_types/1.json
  def destroy
    @producttype = ProductType.find(params[:id])
    @producttype.destroy

    respond_to do |format|
      format.html { redirect_to product_types_url }
      format.json { head :ok }
    end
  end
end
