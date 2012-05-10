class DashboardController < ApplicationController
  before_filter :require_user

  def index

    # эта проверка существует на случай тестов, когда у нас никаких статусов не создано
    if CompanyStatus.suspended

      #noinspection RubyResolve
      if current_user.is_agent?
        @suspended_companies = Company.suspended_by_user current_user.id
      else
        @suspended_companies = Company.suspended
      end

    end

    respond_to do |format|
      format.html # index.html.haml
      format.json { head :ok }
    end
  end
end
