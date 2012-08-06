class DashboardController < ApplicationController
  before_filter :require_user

  def index

    # эта проверка существует на случай тестов, когда у нас никаких статусов не создано
    if CompanyStatus.suspended

      #noinspection RubyResolve
      if current_user.is_agent?
        companies = Company.suspended_by_user(current_user.id)
        @suspended_companies = companies.any? ? companies.paginate(:page => params[:page], :per_page => 10) : []
      else
        companies = Company.suspended
        @suspended_companies = companies.any? ? Company.suspended.paginate(:page => params[:page], :per_page => 10) : []
      end
    end

    # Договора на рассмотрении
    @suspended_contracts = Contract.find_all_by_contract_status_id ContractStatus.pending

    respond_to do |format|
      format.html # index.html.haml
      format.json { head :ok }
    end
  end
end
