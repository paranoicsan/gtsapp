class DashboardController < ApplicationController
  before_filter :require_user

  def index

    # эта проверка существует на случай тестов, когда у нас никаких статусов не создано
    if CompanyStatus.suspended

      #noinspection RubyResolve
      if current_user.is_agent?
        @suspended_companies = Company.suspended_by_user(current_user.id).paginate(:page => params[:page], :per_page => 25)
      else
        @suspended_companies = Company.suspended.paginate(:page => params[:page], :per_page => 25)
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
