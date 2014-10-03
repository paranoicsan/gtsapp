# == Schema Information
#
# Table name: contracts_codes
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_contracts_codes_on_id  (id)
#

require 'spec_helper'

describe Contracts::Code do

  it 'has valid factory' do
    code = FactoryGirl.create :contract_code
    code.should be_valid
  end

end
