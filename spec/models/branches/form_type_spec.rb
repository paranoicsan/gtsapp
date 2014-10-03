# == Schema Information
#
# Table name: branches_form_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_branches_form_types_on_id  (id)
#

describe Branches::FormType do

  it 'has valid factory' do
    type = FactoryGirl.create :form_type
    type.should be_valid
  end

end
