describe Keyword do
  it 'has correct factory' do
    kw = FactoryGirl.create :keyword
    kw.should be_valid
  end
end