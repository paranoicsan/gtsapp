require 'spec_helper'

describe Rubrics::Keyword do
  it 'has correct factory' do
    kw = FactoryGirl.create :keyword
    kw.should be_valid
  end
end