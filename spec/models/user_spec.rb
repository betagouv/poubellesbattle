require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { @user = create(:user, password: 'password123', password_confirmation: 'password123') }
  it 'is database authenticable' do
    # user = create(:user, password: 'password123', password_confirmation: 'password123')
    expect(@user.valid_password?('password123')).to be_truthy
  end
  it 'rejects too short password' do
    # user = create(:user)
    @user.password = 'abc'
    expect(@user).to_not be_valid
  end

  # removed mailers for DEMO version
  # it 'sends welcome email' do
  #   expect { @user.instance_eval { send_welcome_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #   expect(ActionMailer::Base.deliveries.last.subject).to eq('Bienvenue sur Poubelles Battle')
  #   expect(ActionMailer::Base.deliveries.last.to.first).to eq(@user.email)
  # end
end
