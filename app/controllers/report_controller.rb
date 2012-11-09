# Encoding: utf-8
require_dependency 'reports/company_by_street_pdf'
require_dependency 'reports/company_by_street_rtf'
require_dependency 'reports/company_by_street_xls'


class ReportController < ApplicationController
  before_filter :require_user
  before_filter :require_system_users

  include RTF

  ##
  # GET /reports
  def index
    respond_to do |format|
      format.html
      format.json { head :ok }
    end
  end

  ##
  # GET /reports/by_agent
  def by_agent
    respond_to do |format|
      format.html
      format.json { head :ok }
    end
  end

  ##
  # GET /reports/company_by_rubric
  def company_by_rubric
    respond_to do |format|
      format.html
      format.json { head :ok }
    end
  end

  ##
  # GET /reports/company_by_street
  def company_by_street
    respond_to do |format|
      format.html
      format.json { head :ok }
    end
  end

  ##
  # POST /reports/prepare_by_agent
  def prepare_by_agent
    agent_id = params[:report_agent]
    @report_agent = User.find agent_id

    start = "1-#{params[:report_period_start][:month]}-#{params[:report_period_start][:year]}"
    end_p = Date.civil params[:report_period_end][:year].to_i, params[:report_period_end][:month].to_i, -1
    #end_p = "#{params[:report_period_end][:day]}-#{params[:report_period_end][:month]}-#{params[:report_period_end][:year]}"

    @report_result = CompanyHistory.where("user_id = ? and created_at >= ? AND created_at <= ? ", agent_id, start, end_p)
    render :layout => false
  end

  ##
  # POST /reports/prepare_company_by_street
  def prepare_company_by_rubric
    # Ищем компании
    case params[:filter].to_sym
      when :active
        cs = Company.active.paginate(:page => params[:page], :per_page => 20)
      when :archived
        cs = Company.archived.paginate(:page => params[:page], :per_page => 20)
      else
        cs = Company.paginate(:page => params[:page], :per_page => 20)
    end

    companies = []
    rubric = Rubric.find(params[:report_rubric])
    cs.find_all{ |item| item.rubrics.include?(rubric) }.each do |c|
      companies << c
    end
    @report_result = {
        companies: companies,
        rubric_name: rubric.name,
        rubric: rubric,
        filter: params[:filter] ? params[:filter].to_sym : -1
    }
    store_params # сохраняем в сессии параметры

    render :layout => false
  end

  ##
  # POST /reports/prepare_company_by_street
  def prepare_company_by_street
    street_id = params[:street_id]

    # Ищем компании
    companies = Company.by_street street_id, params

    @report_result = {
        street: Street.find(street_id),
        companies: companies,
        filter: params[:filter].eql?("active") ? :active : :all,
        rubricator_filter: params[:rubricator_filter].to_i
    }
    store_params # сохраняем в сессии параметры

    render :layout => false
  end

  ##
  # GET /reports/company_by_street/export/:format
  def company_by_street_export
    unless params[:format]
      render :nothing => true
    end
    format = params[:format].downcase
    data = export_company_by_street(format)

    unless data.nil?
      send_data data,
                :filename => "company_by_street_export.#{format}",
                :type => ReportHelper.mime_type(format)
    end
  end

  ##
  # Экспортирует отчёт в различные форматы
  # @param [String] Формат, в котором надо выгружать результаты
  def export_company_by_street(format)
    case format
      when "pdf"
        rep = ReportCompanyByStreetPDF.new
        rep.street_id = session[:report_params][:street_id]
        rep.filter = session[:report_params][:filter]
        rep.filter_rubricator = session[:report_params][:rubricator_filter].to_i
        rep.to_pdf
      when "rtf"
        rep = ReportCompanyByStreetRTF.new(Font.new(Font::ROMAN, 'Times New Roman'))
        rep.street_id = session[:report_params][:street_id]
        rep.filter = session[:report_params][:filter]
        rep.filter_rubricator = session[:report_params][:rubricator_filter].to_i
        rep.to_rtf
      when "xls"
        rep = ReportCompanyByStreetXLS.new
        rep.street_id = session[:report_params][:street_id]
        rep.filter = session[:report_params][:filter]
        rep.filter_rubricator = session[:report_params][:rubricator_filter].to_i

        rep.to_xls

        path = StringIO.new
        rep.write path
        path.string
      else
        nil
    end
  end

  ##
  # Сохраняет параметры отчёта в сессии
  private
  def store_params
    session[:report_params] = {
        street_id: @report_result[:street] ? @report_result[:street].id : -1,
        filter: @report_result[:filter] ? @report_result[:filter] : -1,
        rubric_name: @report_result[:rubric_name],
        rubricator_filter: @report_result[:rubricator_filter] ? @report_result[:rubricator_filter] : -1
    }
  end


end
