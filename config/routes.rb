Rails.application.routes.draw do
  devise_for :users

  resources :composteurs do
    member do
      post :send_email
    end
  end
  post "composteurs/:id/inscription_composteur", to: "composteurs#inscription_composteur", as: 'inscription'
  post "composteurs/:id/referent_composteur", to: "composteurs#referent_composteur", as: 'referent'
  post "composteurs/:id/validation_referent_composteur", to: "composteurs#validation_referent_composteur", as: 'validation_referent'
  post "composteurs/:id/desincription_composteur", to: "composteurs#desinscription_composteur", as: 'desinscription'
  post "composteurs/:id/non_referent_composteur", to: "composteurs#non_referent_composteur", as: 'non_referent'

  root to: "composteurs#index"

  resources :demandes, param: :slug
  get "/demandes/suivre/:slug", to: "demandes#suivre", as: 'suivre'

  resources :notifications

  resources :donverts
end
