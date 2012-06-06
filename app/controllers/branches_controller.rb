# encoding: utf-8
class BranchesController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :require_system_users, :only => [:delete_website]
  before_filter :get_company

  def index
    @branches = Branch.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @branches }
    end
  end

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
      format.html # new.html.erb
      format.json { render json: @branch }
    end
  end

  # GET /branches/1/edit
  def edit
    @branch = Branch.find(params[:id])
  end

  # POST /companies/:company_id/branches
  # POST /companies/:company_id/branches.json
  def create
    params[:branch][:company_id] = params[:company_id]
    @branch = Branch.new(params[:branch])

    respond_to do |format|
      if @branch.save
        format.html { redirect_to @branch, notice: 'Филиал добавлен.' }
        format.json { render json: @branch, status: :created, location: @branch }
      else
        format.html { render action: "new" }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /branches/1
  # PUT /branches/1.json
  def update
    @branch = Branch.find(params[:id])
    @company = @branch.company

    respond_to do |format|
      if @branch.update_attributes(params[:branch])
        format.html { redirect_to @branch, notice: 'Филиал изменён.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @branch = Branch.find(params[:id])
    company_id = @branch.company_id

    @branch.destroy

    respond_to do |format|
      format.html { redirect_to company_url company_id }
      format.json { head :ok }
    end
  end

  # Определяет родительскую компанию
  def get_company
    @company = Company.find(params[:company_id]) if params[:company_id]
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
  #
  # Добавляет указанный веб-сайт к филиалу
  #
  def add_website
    @branch = Branch.find params[:id]
    if params[:branch_website]
      ws_name = params[:branch_website].strip

      if Website.valid? ws_name

        ws = Website.find_by_name ws_name

        if ws
          flash[:website_error] = "Такой веб-сайт уже существует!"
        else
          ws = Website.new :name => ws_name

          # Если такой сайт есть в БД, но не привязан к филиалу
          # привязываем его, иначе, сначала добавляем в БД, и потом
          # привязываем
          #noinspection RubyResolve
          unless @branch.websites.include? ws
            #noinspection RubyResolve
            @branch.websites << ws
          end

        end

      else
        flash[:website_error] = "Требуемый формат: http://www.example.com."
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
    @branch = Branch.find params[:id]
    ws = Website.find params[:website_id]
    if @branch.websites.include? ws
      @branch.websites.delete ws
    end
    Website.delete ws
    respond_to do |format|
      format.js { render :action => "add_website" }
    end
  end
end
