class DashboardController < ApplicationController
  before_filter :require_user

  def index

    if CompanyStatus.pending
      status_id = CompanyStatus.pending.id
      @suspended_companies = Company.find_all_by_company_status_id status_id
    end

    respond_to do |format|
      format.html # index.html.haml
      format.json { head :ok }
    end
  end
end
