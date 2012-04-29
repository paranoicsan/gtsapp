# encoding: utf-8
class CompaniesController < ApplicationController
  helper :application
  before_filter :require_user

  # Подготавливает значения рубрикатора для вставки в СУБД
  # @param params [Hash] массив значений выбранных Checkbox-объектов
  # @return [Integer] финальное значение
  def self.prepare_rubricator(params)
    r = 0
    if params.is_a?(Hash)
      params.each_value { |v| r += Integer(v) }
    end
    r
  end

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = Company.find(params[:id])
    @branches = Branch.find_all_by_company_id(@company.id)
    @branches_sorted = Branch.order("is_main DESC, fact_name ASC").find_all_by_company_id(@company.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new
    @branches = []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    @branches = Branch.find_all_by_company_id(params[:id])
    @branches = @branches ? @branches : []
  end

  # POST /companies
  # POST /companies.json
  def create

    # Определяем права пользователя и в зависимости от этого задаем статус
    #noinspection RubyResolve
    status = current_user.is_admin? || current_user.is_operator? ? CompanyStatus.active : CompanyStatus.pending
    params[:company][:company_status] = status

    # Автор и редактор!
    params[:company][:author_user_id] = @current_user.id
    params[:company][:editor_user_id] = @current_user.id

    # Обрабатываем рубрикатор
    params[:company][:rubricator] = CompaniesController.prepare_rubricator(params[:company][:rubricator])


    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Компания добавлена' }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    # Обрабатываем рубрикатор
    params[:company][:rubricator] = CompaniesController.prepare_rubricator(params[:company][:rubricator])

    # Редактор
    params[:company][:editor_user_id] = @current_user.id

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :ok }
    end
  end
end
