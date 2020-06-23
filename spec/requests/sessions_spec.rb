require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it "signs user in and out" do
    user = create(:user)
    expect(user).to be_valid
    sign_in user
    get root_path
    expect(response.body).to include('Me deconnecter')

    sign_out user
    get root_path
    expect(response.body).to include('Se connecter')
  end
end
