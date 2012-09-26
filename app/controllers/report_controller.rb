# Encoding: utf-8
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

end
