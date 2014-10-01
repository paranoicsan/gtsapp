require 'spec_helper'

describe Users::User do

  it 'has valid factory' do
    user = FactoryGirl.create :user
    user.should be_valid
  end

end