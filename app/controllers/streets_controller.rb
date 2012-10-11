#Encoding: utf-8
require_dependency 'reports/street_by_city_rtf.rb'
require_dependency 'reports/street_by_city_pdf.rb'

class StreetsController < ApplicationController

  include RTF

  helper :application
  before_filter :require_user
  before_filter :require_system_users, :only => [:new, :edit, :update, :create, :destroy]

  # GET /streets
  # GET /streets.json
  def index
    @streets = Street.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @streets }
    end
  end

  # GET /streets/new
  # GET /streets/new.json
  def new
    @street = Street.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @street }
    end
  end

  # GET /streets/1/edit
  def edit
    @street = Street.find(params[:id])
  end

  # POST /streets
  # POST /streets.json
  def create
    @street = Street.new(params[:street])

    respond_to do |format|
      if @street.save
        format.html { redirect_to streets_path, notice: 'Street was successfully created.' }
        format.json { render json: @streets, status: :created, location: @street }
      else
        format.html { render action: "new" }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /streets/1
  # PUT /streets/1.json
  def update
    @street = Street.find(params[:id])

    respond_to do |format|
      if @street.update_attributes(params[:street])
        format.html { redirect_to streets_path, notice: 'Street was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streets/1
  # DELETE /streets/1.json
  def destroy

    begin
      message = nil
      @street = Street.find(params[:id])
      @street.destroy
    rescue
      message = %Q{Улица не может быть удалена. Она используется по крайней мере одним филиалом.}
    end

    # определяем сообщение
    params = message ? { error: message } : {}

    respond_to do |format|
      format.html { redirect_to streets_url, flash: params }
      format.json { head :ok }
    end

  end

  ##
  # POST streets_by_city
  def streets_by_city
    @streets_by_city = []
    if params[:city_id]
      @streets_by_city = Street.where('city_id = ?', params[:city_id]).order("name").paginate(:page => params[:page], :per_page => 100)
    end
    store_params # сохраняем параметры в сессии
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  ##
  # GET /sreets/export/:format
  def streets_by_city_export
    unless params[:format]
      render :nothing => true
    end
    format = params[:format].downcase
    data = export_by_city(format)
    if data.nil?
      redirect_to streets_path, notice: 'Возникли ошибки при формирования отчёта'
    else
      send_data data,
                :filename => "streets.#{format}",
                :type => ReportHelper.mime_type(format)
    end
  end

  ##
  # Экспортирует отчёт в различные форматы
  # @param [String] Формат, в котором надо выгружать результаты
  def export_by_city(format)
    case format
      when "pdf"
        rep = ReportStreetByCityPDF.new
        rep.city_id = session[:report_params][:city_id]
        rep.get_data
      when "rtf"
        rep = ReportStreetByCityRTF.new(Font.new(Font::ROMAN, 'Times New Roman'))
        rep.city_id = session[:report_params][:city_id]
        rep.get_data
      when "xls"
        #rep = ReportCompanyByStreetXLS.new
        #rep.street_id = session[:report_params][:street_id]
        #rep.filter = session[:report_params][:filter]
        #rep.filter_rubricator = session[:report_params][:rubricator_filter].to_i
        #
        #rep.to_xls
        #
        #path = StringIO.new
        #rep.write path
        #path.string
      else
        nil
    end
  end

  ##
  # Сохраняет параметры отчёта в сессии
  private
  def store_params
    session[:report_params] = {
        city_id: params[:city_id] ? params[:city_id].to_i : nil
    }
  end

end
