class DashboardController < ApplicationController
  before_filter :require_user

  def index
    respond_to do |format|
      format.html # index.html.haml
      format.json { head :ok }
    end
  end
end
