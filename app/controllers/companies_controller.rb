# encoding: utf-8
class CompaniesController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_system_users, :only => [:activate, :request_improvement, :request_improvement_reason]
  autocomplete :rubric, :name

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
    @companies = Company.paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = Company.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new
    #@branches = []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    #@branches = Branch.find_all_by_company_id(params[:id])
    #@branches = @branches ? @branches : []
  end

  # POST /companies
  # POST /companies.json
  def create

    # Определяем права пользователя и в зависимости от этого задаем статус
    #noinspection RubyResolve
    status = current_user.is_admin? || current_user.is_operator? ? CompanyStatus.active : CompanyStatus.suspended
    params[:company][:company_status] = status

    # Автор и редактор
    params[:company][:author_user_id] = current_user.id
    params[:company][:editor_user_id] = current_user.id

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
    params[:company][:editor_user_id] = current_user.id

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

  ##
  #
  # Активирует указанную компанию - устанавливает ей статус как "Активна"
  # GET /companies/1/activate
  def activate
    Company.activate params[:id]
    # перебрасываем туда, откуда пришли
    #redirect_to dashboard_url
    redirect_to request.referer
  end

  ##
  #
  # Добавляет рубрику к компании
  # GET /companies/1/add_rubric/2
  def add_rubric
    @company = Company.find params[:id]
    rub = Rubric.find params[:rub_id]
    # проверяем, не добавляли ли раньше эту рубрику
    unless @company.rubrics.include? rub
      @company.rubrics << rub
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  ##
  #
  # Удаляет компанию из рубрики
  # GET /companies/1/delete_rubric/2
  def delete_rubric
    @company = Company.find params[:id]
    rub = Rubric.find params[:rub_id]
    if @company.rubrics.include? rub
      @company.rubrics.delete rub
    end
    respond_to do |format|
      format.js { render :action => "add_rubric" }
    end
  end

  ##
  # POST companies/:id/queue_for_delete
  # выставляет компанию на удаление
  def queue_for_delete
    @company = Company.find params[:id]
    @company.queue_for_delete params[:company][:reason_deleted_on]
    if @company.save
      render :layout => false # отправка обратно JS-ответа с командой на закрытие диалога
    else
      render :template => 'companies/re_request_delete_reason'
    end
  end

  ##
  # GET companies/:id/unqueue_for_delete
  # снимает компанию с очереди на удаление
  def unqueue_for_delete
    @company = Company.find params[:id]

    # определяем текущего пользователя
    # и в зависимости от этого меняет статус
    status = current_user.is_agent? ? :suspended : :active
    @company.unqueue_for_delete status

    if @company.save
      ref = request ? request.env['HTTP_REFERER'] : ''
      if ref.eql?(company_path(@company))

        render :layout => false # посылка JS-ответа
      else
        redirect_to request.env['HTTP_REFERER'] ? :back : root_url
      end
    end
  end

  ###
  ## GET companies/:id/request_delete
  def request_delete_reason
    @company = Company.find params[:id]
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  ###
  ## GET companies/:id/request_attention_reason
  def request_attention_reason
    @company = Company.find params[:id]
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  ##
  # POST companies/:id/request_attention
  # Меняет компании статус как "Требует внимания"
  def request_attention
    @company = Company.find params[:id]
    params[:company][:company_status] = CompanyStatus.need_attention
    @company.update_attributes(params[:company])

    if @company.save
      render :layout => false # отправка обратно JS-ответа с командой на закрытие диалога
    else
      render :template => 'companies/re_request_attention_reason'
    end
  end

  ###
  ## GET companies/:id/request_improvement_reason
  def request_improvement_reason
    @company = Company.find params[:id]
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  ##
  # POST companies/:id/request_improvement
  # Меняет компании статус как "Требует внимания"
  def request_improvement
    @company = Company.find params[:id]
    params[:company][:company_status] = CompanyStatus.need_improvement
    @company.update_attributes(params[:company])

    if @company.save
      render :layout => false # отправка обратно JS-ответа с командой на закрытие диалога
    else
      render :template => 'companies/re_request_improvement_reason'
    end
  end

  ##
  # GET companies/:id/improve
  # Завершает доработку и ставит компанию как "Повторное рассмотрение"
  def improve
    c = Company.find params[:id]
    c.update_attributes({
                        company_status: CompanyStatus.second_suspend,
                        reason_need_improvement_on: nil
                            })
    redirect_to request.referer
  end

  ##
  # POST companies/validate_title
  # Проверяет валидность указанного названия компании
  def validate_title
    @company = Company.find_by_title params[:company_title]
    respond_to do |format|
      format.html { render :partial => 'validate_title', :layout => false }
    end
  end
end
