Rails.application.routes.draw do
  devise_for :users

  resources :composteurs do
    member do
      post :send_email
    end
  end

  get "referents", to: "composteurs#annuaire_ref", as: 'referents'
  post "composteurs/:id/inscription_par_referent", to: "composteurs#inscription_par_referent", as: 'inscription_par_referent'
  post "composteurs/:id/inscription_composteur", to: "composteurs#inscription_composteur", as: 'inscription'
  post "composteurs/:id/referent_composteur", to: "composteurs#referent_composteur", as: 'referent'
  post "composteurs/:id/validation_referent_composteur", to: "composteurs#validation_referent_composteur", as: 'validation_referent'
  post "composteurs/:id/ajout_referent_composteur", to: "composteurs#ajout_referent_composteur", as: 'ajout_referent'
  post "composteurs/:id/desincription_composteur", to: "composteurs#desinscription_composteur", as: 'desinscription'
  post "composteurs/:id/non_referent_composteur", to: "composteurs#non_referent_composteur", as: 'non_referent'
  post "composteurs/:id/new_manual_latlng", to: "composteurs#new_manual_latlng", as: 'new_manual_latlng'
  post "composteurs/:id/suppr_manual_latlng", to: "composteurs#suppr_manual_latlng", as: 'suppr_manual_latlng'

  root to: "composteurs#index"

  resources :demandes, param: :slug
  get "/demandes/suivre/:slug", to: "demandes#suivre", as: 'suivre'
  post "demandes/:slug/formulaire_toggle", to: "demandes#formulaire_toggle", as: 'formulaire_toggle'

  resources :notifications
  post "notifications/:id/resolved", to: "notifications#resolved", as: "resolved"

  get "bourse_verte/mes_dons", to: "donverts#mes_dons", as: "mes_dons"
  resources :donverts, path: 'bourse_verte', param: :slug
  post "bourse_verte/:slug/pourvu", to: "donverts#pourvu", as: "pourvu"
  post "bourse_verte/:slug/archive", to: "donverts#archive", as: "archive"
  get "bourse_verte/:slug/link", to: "donverts#link", as: "link"

  resources :messages, only: [:new, :create]

  get "stats", to: "pages#stats", as: 'stats'
end
