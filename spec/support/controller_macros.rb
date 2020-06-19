module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryBot.create(:user, role: 2) # Using factory bot as an example
    end
  end

  def login_referent
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user, role: 1, composteur_id: Composteur.last.id)
      sign_in user
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user, role: 0, composteur_id: Composteur.last.id)
      sign_in user
    end
  end

  def login(user)
    puts "controllllllers"
    post new_user_session_path, login: user.email, password: '123456'
  end
end
