describe Branches::FormType do

  it 'has valid factory' do
    type = FactoryGirl.create :form_type
    type.should be_valid
  end

end