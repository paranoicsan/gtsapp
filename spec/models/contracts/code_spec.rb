# == Schema Information
#
# Table name: contracts_codes
#
#  id   :integer          not null, primary key
#  name :string(255)
#

require 'spec_helper'

describe Contracts::Code do

  it 'has valid factory' do
    code = FactoryGirl.create :contract_code
    code.should be_valid
  end

end
