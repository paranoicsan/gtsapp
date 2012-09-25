# Encoding: utf-8
require 'spec_helper'

describe ReportController do

  before(:each) do
    make_user_system
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
