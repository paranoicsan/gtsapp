# Encoding: utf-8
require 'spec_helper'

describe Keyword do
  it "фабрика корректна" do
    kw = FactoryGirl.create :keyword
    kw.should be_valid
  end
end