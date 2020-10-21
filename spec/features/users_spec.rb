require 'rails_helper'

RSpec.describe "Users", type: :feature do
  # no more Sign-up in the DEMO
  # describe "creating new account + destroy this account" do
  #   it "creates a new user and destroys a new user" do
  #     visit '/users/sign_up'
  #     within '#new_user' do
  #       fill_in 'Email', with: "user.email@mail.com"
  #       fill_in 'user_password', with: '123456'
  #       fill_in 'user_password_confirmation', with: '123456'
  #       fill_in 'user_first_name', with: 'Jean Pierre'
  #       fill_in 'user_last_name', with: 'Patrick'
  #     end
  #     click_button "S'inscrire"
  #     expect(page).to have_text('Bienvenue, vous êtes connecté.')

  #     click_link "Modifier mon profil"
  #     expect(page).to have_selector('h2', text: 'Jean Pierre Patrick')
  #     expect(page).to have_selector('form', id: 'edit_user')

  #     click_link 'Oui, cloturez mon compte !'
  #     expect(page).to have_text('Votre compte a été supprimé avec succès. Nous espérons vous revoir bientôt.')
  #   end
  # end
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
