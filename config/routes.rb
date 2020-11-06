Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations"}

  # match '(*any)', to: redirect(subdomain: ''), via: :all, constraints: {subdomain: 'www'} if Rails.env.production?

  resources :composteurs, only: [:index, :show, :update], param: :slug
  root to: "composteurs#index"
  post "composteurs/:slug/inscription_par_referent", to: "composteurs#inscription_par_referent", as: 'inscription_par_referent'
  post "composteurs/:slug/inscription_composteur", to: "composteurs#inscription_composteur", as: 'inscription'
  post "composteurs/:slug/referent_composteur", to: "composteurs#referent_composteur", as: 'referent'
  post "composteurs/:slug/validation_referent_composteur", to: "composteurs#validation_referent_composteur", as: 'validation_referent'
  post "composteurs/:slug/desincription_composteur", to: "composteurs#desinscription_composteur", as: 'desinscription'
  post "composteurs/:slug/non_referent_composteur", to: "composteurs#non_referent_composteur", as: 'non_referent'

  resources :demandes, only: [:new, :create], param: :slug
  get "demandes/suivre/:slug", to: "demandes#suivre", as: 'suivre'

  resources :notifications, only: [:show, :new, :create, :destroy]
  post "notifications/:id/resolved", to: "notifications#resolved", as: "resolved"
  get "anonymous_depot", to: "notifications#anonymous_depot", as: "anonymous_depot"

  resources :messages, only: [:new, :create]

  get "bourse_verte/mes_dons", to: "donverts#mes_dons", as: "mes_dons"
  resources :donverts, path: 'bourse_verte', only: [:index, :show, :new, :create], param: :slug
  post "bourse_verte/:slug/pourvu", to: "donverts#pourvu", as: "pourvu"
  post "bourse_verte/:slug/archive", to: "donverts#archive", as: "archive"
  get "bourse_verte/:slug/link", to: "donverts#link", as: "link"

  get 'stats', to: 'pages#stats', as: 'stats'
  get 'vieprivee', to: 'pages#vieprivee', as: 'vieprivee'
  get 'ca-se-composte', to: 'pages#to_compost', as: 'composter_ou_non'

  # ADMINS ROUTES
  namespace :admin do
    delete "users/:id", to: "users#destroy", as: 'destroy_user'
    resources :composteurs, only: [:index, :new, :create, :edit, :update, :destroy], param: :slug
    post "composteurs/:slug/new_manual_latlng", to: "composteurs#new_manual_latlng", as: 'new_manual_latlng'
    post "composteurs/:slug/suppr_manual_latlng", to: "composteurs#suppr_manual_latlng", as: 'suppr_manual_latlng'
    post "composteurs/:slug/ajout_referent_composteur", to: "composteurs#ajout_referent_composteur", as: 'ajout_referent'
    post "composteurs/:slug/non_referent_composteur", to: "composteurs#non_referent_composteur", as: 'non_referent'
    resources :demandes, only: [:index, :edit, :update, :destroy], param: :slug
    post "demandes/:slug/formulaire_toggle", to: "demandes#formulaire_toggle", as:'formulaire_toggle'
    resources :donverts, only: :destroy, path: 'bourse_verte', param: :slug
    resources :notifications, only: [:index, :new, :create, :destroy]
    # pages controller
    get "annuaire", to: "pages#annuaire", as: 'annuaire'
    get "users_export", to: "pages#users_export", as: 'users_export'
    get "users_newsletter", to: "pages#users_newsletter", as: 'users_newsletter'
  end
end
