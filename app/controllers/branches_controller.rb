# encoding: utf-8
class BranchesController < ApplicationController

  helper :application

  before_filter :assign_branch, except: [:new, :create]
  before_filter :assign_company,
                :require_user
  before_filter :require_system_users, only: [:delete_website]

  # GET /branches/1
  def show
    @branch = Branch.find(params[:id])
    @company = @branch.company

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @branch }
    end
  end

  def new
    @branch = Branch.new
    respond_to do |format|
      format.html
    end
  end

  # GET /branches/1/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # POST /companies/:company_id/branches
  def create
    @branch = Branch.new params[:branch]
    @branch.company = @company

    respond_to do |format|
      if @branch.save
        log_operation :branch, :create, @branch.company.id
        format.html { redirect_to @branch, notice: 'Филиал добавлен.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /branches/1
  def update
    @company ||= @branch.company
    respond_to do |format|
      if @branch.update_attributes(params[:branch])
        log_operation :branch, :update, @company.id
        format.html { redirect_to @branch, notice: 'Филиал изменён.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /branches/1
  def destroy
    @company ||= @branch.company
    log_operation :branch, :destroy, @company.id
    @branch.destroy
    respond_to do |format|
      format.html { redirect_to company_url @company }
    end
  end

  ##
  #
  # Устанавливает указанный филиал как основной
  #
  def make_main
    @branch = Branch.find(params[:id])
    @branch.make_main
    company_id = @branch.company_id
    redirect_to company_url company_id
  end

  ##
  # Добавляет указанный веб-сайт к филиалу
  # POST branches/:id/add_website
  def add_website
    if params[:branch_website]
      ws_name = params[:branch_website].strip
      if Website.valid? ws_name

        ws = Website.find_by_name ws_name
        ws = ws ? ws : Website.new(:name => ws_name)

          # Если такой сайт есть в БД, но не привязан к филиалу
          # привязываем его, иначе, сначала добавляем в БД, и потом
          # привязываем
          #noinspection RubyResolve
          if @branch.websites.include? ws
            flash[:website_error] = "Такой веб-сайт уже связан с этим филиалом."
          else
            @branch.websites << ws
            log_operation :website, :add, @branch.company.id
          end

      else
        flash[:website_error] = "Формат: http://www.example.com и ВашСайт.рф."
      end
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  ##
  #
  # Удаляет веб-сайт от филиала и вообще из системы
  #
  def delete_website
    ws = Website.find params[:website_id]
    @branch.websites.delete(ws) if @branch.websites.include?(ws)
    Website.delete ws
    log_operation :website, :remove, @branch.company.id
    respond_to do |format|
      format.js { render :action => "add_website" }
    end
  end

  ##
  # Добавляет указанный адрес электронной почты к филиалу
  # POST branches/:id/add_email
  def add_email
    if params[:branch_email]
      em_name = params[:branch_email].strip
      if Email.valid? em_name
        em = Email.find_by_name_and_branch_id em_name, @branch.id
        if em
          flash[:email_error] = "Такой адрес электронной почты уже существует."
        else
          em = Email.new :name => em_name
          @branch.emails << em
          log_operation :email, :add, @branch.company.id
        end
      else
        flash[:email_error] = "Неверный адрес электронной почты."
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  ##
  # Удаляет адрес электронной почты от филиала и вообще из системы
  # GET branches/:id/delete_email/:email_id
  def delete_email
    em = Email.find params[:email_id]
    if @branch.emails.include? em
      @branch.emails.delete em
    end
    Email.delete em
    log_operation :email, :remove, @branch.company.id
    respond_to do |format|
      format.js { render :action => "add_email" }
    end
  end

  def assign_branch
    @branch = Branch.find params[:id]
  end

  # Определяет родительскую компанию
  def assign_company
    @company = Company.find(params[:company_id]) if params[:company_id]
  end

end
