# Encoding: utf-8
require "company_by_street_pdf"

class ReportController < ApplicationController
  before_filter :require_user
  before_filter :require_system_users

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
  def prepare_company_by_street
    street_id = params[:street_id]

    # Ищем компании
    companies = []
    Address.by_street(street_id).each do |a|
      if a.branch.is_main
        c = a.branch.company

        # для полного рубрикатора всегда есть попадание в любое условие
        if c.rubricator.eql?(params[:rubricator_filter].to_i) || c.rubricator.eql?(3)
          if params[:filter] == "active"
            companies << c if c.active?
          else
            companies << c
          end
        end
      end
    end

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
    send_data export_company_by_street,
              :filename => "company_by_street_export.#{params[:format]}",
              :type => "application/pdf"
  end

  def export_company_by_street
    case params[:format].downcase
      when "pdf"
        rep = ReportCompanyByStreetPDF.new
        rep.street_id = session[:report_params][:street_id]
        rep.to_pdf
      else
        nil
    end
  end

  ##
  # Сохраняет параметры отчёта в сессии
  private
  def store_params
    session[:report_params] = {
        street_id: @report_result[:street].id,
        filter: @report_result[:filter],
        rubricator_filter: @report_result[:rubricator_filter],
    }
  end


end
