require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it "signs user in and out" do
    user = create(:user)

    expect(user).to be_valid
    sign_in user
    get root_path
    follow_redirect!
    expect(response.body).to include('Se déconnecter')

    sign_out user
    get root_path
    # expect(response.body).not_to include('Se déconnecter')
  end
end
