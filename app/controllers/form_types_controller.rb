class FormTypesController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_operator, :only => [:new, :edit, :update, :create, :destroy]

  # GET /form_types
  # GET /form_types.json
  def index
    @form_types = FormType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @form_types }
    end
  end

  # GET /form_types/1
  # GET /form_types/1.json
  def show
    @form_type = FormType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @form_type }
    end
  end

  # GET /form_types/new
  # GET /form_types/new.json
  def new
    @form_type = FormType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @form_type }
    end
  end

  # GET /form_types/1/edit
  def edit
    @form_type = FormType.find(params[:id])
  end

  # POST /form_types
  # POST /form_types.json
  def create
    @form_type = FormType.new(params[:form_type])

    respond_to do |format|
      if @form_type.save
        format.html { redirect_to @form_type, notice: 'Form type was successfully created.' }
        format.json { render json: @form_type, status: :created, location: @form_type }
      else
        format.html { render action: "new" }
        format.json { render json: @form_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /form_types/1
  # PUT /form_types/1.json
  def update
    @form_type = FormType.find(params[:id])

    respond_to do |format|
      if @form_type.update_attributes(params[:form_type])
        format.html { redirect_to @form_type, notice: 'Form type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @form_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_types/1
  # DELETE /form_types/1.json
  def destroy
    @form_type = FormType.find(params[:id])
    @form_type.destroy

    respond_to do |format|
      format.html { redirect_to form_types_url }
      format.json { head :ok }
    end
  end
end
