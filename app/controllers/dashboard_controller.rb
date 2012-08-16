class DashboardController < ApplicationController
  before_filter :require_user

  def index

    @queued_for_delete_companies = queued_for_delete_companies  # Компании в очередеи на удаление
    @suspended_companies = suspended_companies # Компании на рассмотрении
    @suspended_contracts = suspended_contracts # Договора на рассмотрении

    respond_to do |format|
      format.html # index.html.haml
      format.json { head :ok }
    end
  end

  private
    def suspended_contracts
      Contract.find_all_by_contract_status_id ContractStatus.pending
    end

    def queued_for_delete_companies
      Company.queued_for_delete
    end

    def suspended_companies
      #noinspection RubyResolve
      if current_user.is_agent?
        Company.suspended_by_user(current_user.id).paginate(:page => params[:page], :per_page => 10)
      else
        Company.suspended.paginate(:page => params[:page], :per_page => 10)
      end
    end
end
