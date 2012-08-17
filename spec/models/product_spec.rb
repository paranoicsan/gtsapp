# Encoding: utf-8
require 'spec_helper'

describe Product do

  it "фабрика корректна" do
    FactoryGirl.create(:product).should be_valid
  end

end