require 'rails_helper'

RSpec.describe "Composteurs", type: :feature do
  describe "GET /root_path -- testing redirects after login" do
    before {
            first_composteur = create(:composteur)
            second_composteur = create(:composteur)
            compostophile = create(:user, role: 0, composteur_id: first_composteur.id)
            referent = create(:user, role: 1, composteur_id: first_composteur.id)
            admin = create(:user, role: 2)
           }

    describe "when NOT SIGNED IN" do
      it "returns the home page with 2 composteurs and the map" do
        visit composteurs_path

        expect(page).to have_text("les 2 composteurs collectifs")
      end
    end
    describe "when SIGNED IN as compostophile with composteur assigned" do
      it "redirects to the compostophile's composteur page" do
        user = create(:user, role: 0, composteur_id: Composteur.last.id)
        second_referent = create(:user, role: 1, composteur_id: Composteur.last.id)
        visit '/users/sign_in'
        within '#new_user' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: '123456'
        end
        click_button 'Se connecter'
        expect(page).to have_text(user.first_name)
        expect(page).to have_text(second_referent.first_name)
        expect(page).to have_text(Composteur.last.name)
      end
    end
    describe "when SIGNED IN as referent with composteur assigned" do
      it "redirects to the referent's composteur page" do
        user = create(:user, role: 0, composteur_id: Composteur.last.id)
        second_referent = create(:user, role: 1, composteur_id: Composteur.last.id)
        visit '/users/sign_in'
        within '#new_user' do
          fill_in 'Email', with: second_referent.email
          fill_in 'Password', with: '123456'
        end
        click_button 'Se connecter'
        expect(page).to have_text(user.first_name)
        expect(page).to have_text(second_referent.first_name)
        expect(page).to have_text(Composteur.last.name)
      end
    end
    describe "when SIGNED IN as admin" do
      it "redirects to the admin home page" do
        user_admin = create(:user, role: 2, composteur_id: Composteur.last.id)
        visit '/users/sign_in'
        within '#new_user' do
          fill_in 'Email', with: user_admin.email
          fill_in 'Password', with: '123456'
        end
        click_button 'Se connecter'
        expect(page).to have_text(Composteur.first.name)
        expect(page).to have_text(Composteur.last.address)
      end
    end
    User.destroy_all
    Composteur.destroy_all
  end
end
