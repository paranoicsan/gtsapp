module DeviseMacros

  def login_as_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = FactoryGirl.create :user
      sign_in @user
    end
  end

  def login_as_operator
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = FactoryGirl.create :user_operator
      sign_in @user
    end
  end

  def login_as_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = FactoryGirl.create :user_admin
      sign_in @user
    end
  end

end
