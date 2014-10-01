class Address::CitiesController < ApplicationController

  before_filter :check_operator!, except: [:index, :show]
  before_filter :assign_city, except: [:index, :new, :create]

  def index
    @cities = Addresses::City.all
  end

  def show
  end

  def new
    @city = Addresses::City.new
  end

  def edit
  end

  def create
    @city = Addresses::City.new params[:city]

    if @city.save
      redirect_to city_path(@city), notice: 'City was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @city.update_attributes(params[:city])
      redirect_to city_path(@city), notice: 'City was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_url
  end

  private

  def assign_city
    @city = Addresses::City.find params[:id]
  end

end
