class PeopleController < ApplicationController
  helper :application
  before_filter :require_user
  before_filter :get_company


  # GET /people
  # GET /people.json
  def index
    @people = Person.all
    redirect_to root_url
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @people }
    #end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])
    @company = @person.company

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    params[:person][:company_id] = params[:company_id]
    @person = Person.new(params[:person])
    @company = @person.company

    respond_to do |format|
      if @person.save
        log_operation :person, :create, @company.id
        format.html { redirect_to company_path(@person.company), notice: 'Person was successfully created.' }
        format.json { render json: @person, status: :created, location: @person }
      else
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])
    @company = @person.company

    respond_to do |format|
      if @person.update_attributes(params[:person])
        log_operation :person, :update, @company.id
        format.html { redirect_to @company, notice: 'Person was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    company_id = @person.company_id
    log_operation :person, :destroy, company_id
    @person.destroy

    respond_to do |format|
      format.html { redirect_to company_url company_id }
      format.json { head :ok }
    end
  end

private
  def get_company
    @company = Company.find(params[:company_id]) if params[:company_id]
  end
end