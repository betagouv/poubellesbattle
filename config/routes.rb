Rails.application.routes.draw do
  devise_for :users

  resources :composteurs do
    member do
      post :send_email
    end
  end

  root to: "composteurs#index"

  resources :demandes, param: :slug
  get "/demandes/suivre/:slug", to: "demandes#suivre", as: 'suivre'

  resources :notifications

  resources :donverts
end
