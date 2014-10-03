# == Schema Information
#
# Table name: rubrics_keywords
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_rubrics_keywords_on_id  (id)
#

require 'spec_helper'

describe Rubrics::Keyword do
  it 'has correct factory' do
    kw = FactoryGirl.create :keyword
    kw.should be_valid
  end
end
