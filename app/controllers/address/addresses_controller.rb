class Address::AddressesController < ApplicationController

  before_filter :assign_address, except: [:index, :new, :create]

  autocomplete :city, :name
  autocomplete :street, :name

  def index
    @addresses = Addresses::Address.all
  end

  def show
  end

  def new
    @address = Addresses::Address.new
  end

  def edit
  end

  def create

    params[:address][:branch_id] = params[:branch_id]
    params[:address][:city_id] = params[:city_id]
    params[:address][:street_id] = params[:street_id]

    @address = Addresses::Address.new(params[:address])
    @branch = @address.branch

    if @address.save
      log_operation :address, :create, @branch.company.id
      redirect_to branch_path(@branch), notice: 'Адрес добавлен.'
    else
      render action: 'new'
    end
  end

  def update

    params[:address][:city_id] = params[:city_id]
    params[:address][:street_id] = params[:street_id]

    if @address.update_attributes(params[:address])
      log_operation :address, :update, @branch.company.id
      redirect_to branch_path(@branch), notice: 'Адрес изменён.'
    else
      render action: 'edit'
    end
  end

  def destroy

    log_operation :address, :destroy, @branch.company.id
    @address.destroy

    redirect_to branch_url(@branch)
  end

  ##
  # Переопределяем метод, возвращающий элементы автозаполнения
  # для ограничивания выборки
  def get_autocomplete_items(parameters)
    items = super(parameters)

    if params && params[:city_id]
      # фильтрация улиц
      @city = Addresses::City.find params[:city_id]
      if @city
        items.where(city_id: @city.id)
      end
    else
      # всё остальное
      items.all
    end

  end

  private

  def assign_address
    id = params[:id]
    unless id.nil?
      @address = Addresses::Address.find id
      @branch = @address.branch
    end
  end

end
