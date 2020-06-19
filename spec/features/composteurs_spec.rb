require 'rails_helper'

RSpec.describe "Composteurs", type: :feature do
  describe "GET /composteurs" do
    before {
            first_composteur = create(:composteur)
            second_composteur = create(:composteur)
            compostophile = create(:user, role: 0, composteur_id: first_composteur.id)
            referent = create(:user, role: 1, composteur_id: first_composteur.id)
            admin = create(:user, role: 2)
           }

    describe "when not logged" do
      it "returns the home page with 2 composteurs and the map" do
        visit composteurs_path

        expect(page).to have_text("les 2 composteurs collectifs")
      end
    end
    describe "when logged as compostophile with composteur assigned" do
      it "redirects to composteur page" do
        user = create(:user, role: 0, composteur_id: Composteur.last.id)
        second_referent = create(:user, role: 1, composteur_id: Composteur.last.id)
        visit '/users/sign_in'
        within '#new_user' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: '123456'
        end
        click_button 'Se connecter'
        # pry
        expect(page).to have_text(user.first_name)
        expect(page).to have_text(second_referent.first_name)
        expect(page).to have_text(Composteur.last.name)
        visit composteur_path(Composteur.last)
        save_and_open_page
      end
    end
  end
end
