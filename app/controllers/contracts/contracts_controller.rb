# encoding: utf-8
class ContractsController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_system_users, :only => [:new, :create, :destroy, :update, :edit, :activate]
  # GET /contracts
  # GET /contracts.json
  def index
    @contracts = Contract.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contracts }
    end
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
    @contract = Contract.find(params[:id])
    @company = @contract.company

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contract }
    end
  end

  # GET /contracts/new
  # GET /contracts/new.json
  def new
    @contract = Contract.new
    @company = Company.find params[:company_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contract }
    end
  end

  # GET /contracts/1/edit
  def edit
    @contract = Contract.find(params[:id])
  end

  # POST /contracts
  # POST /contracts.json
  def create
    params[:contract][:company_id] = params[:company_id]

    @contract = Contract.new(params[:contract])
    @company = Company.find params[:company_id]

    # Определяем состояние создаваемого договора
    #noinspection RubyResolve
    @contract.contract_status = ContractStatus.active

    respond_to do |format|
      if @contract.save
        log_operation :contract, :create, @company.id
        format.html { redirect_to @contract, notice: 'Договор добавлен.' }
        format.json { render json: @contract, status: :created, location: @contract }
      else
        format.html { render action: "new" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contracts/1
  # PUT /contracts/1.json
  def update
    @contract = Contract.find(params[:id])

    respond_to do |format|
      if @contract.update_attributes(params[:contract])
        log_operation :contract, :update, @contract.company.id
        format.html { redirect_to @contract, notice: 'Contract was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    @contract = Contract.find(params[:id])
    company_id = @contract.company_id

    log_operation :contract, :destroy, @contract.company.id

    @contract.destroy

    respond_to do |format|
      format.html { redirect_to company_url company_id }
      format.json { head :ok }
    end
  end

  ##
  # Активирует указанный договор
  #
  # GET /contracts/1/activate
  def activate
    Contract.activate params[:id]
    # перебрасываем туда, откуда пришли
    #redirect_to dashboard_url
    redirect_to request.referer
  end

end