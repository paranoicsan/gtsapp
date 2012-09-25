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

end
