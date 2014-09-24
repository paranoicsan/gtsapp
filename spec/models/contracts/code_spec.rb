require 'spec_helper'

describe Contracts::Code do

  it 'has valid factory' do
    code = FactoryGirl.create :contract_code
    code.should be_valid
  end

end