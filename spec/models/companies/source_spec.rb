# == Schema Information
#
# Table name: companies_sources
#
#  id   :integer          not null, primary key
#  name :string(255)
#

require 'spec_helper'

describe Companies::Source do

  it 'has correct factory' do
    source = FactoryGirl.create :company_source
    source.should be_valid
  end

end
