Rails.application.routes.draw do
  devise_for :users

  resources :composteurs do
    member do
      post :send_email
    end
  end

  root to: "composteurs#index"

  resources :demandes
  get "/demandes/suivre/:id", to: "demandes#suivre", as: 'suivre'
  resources :notifications

  resources :donverts
end
