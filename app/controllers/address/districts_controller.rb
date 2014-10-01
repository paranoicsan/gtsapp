class Address::DistrictsController < ApplicationController

  before_filter :check_operator!, except: [:index, :show]
  before_filter :assign_district, except: [:index, :new, :create]

  def index
    @districts = Addresses::District.all
  end

  def show
  end

  def new
    @district = Addresses::District.new
  end

  def edit
  end

  def create
    @district = Addresses::District.new params[:district]

    if @district.save
      redirect_to district_path(@district), notice: 'District was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @district.update_attributes(params[:district])
      redirect_to district_path(@district), notice: 'District was successfully updated.'
    else
      render action: 'edit'
    end
end

  def destroy
    @district.destroy
    redirect_to districts_url
  end

  private

  def assign_district
    @district = Addresses::District.find params[:id]
  end

end
