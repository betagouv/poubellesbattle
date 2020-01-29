Rails.application.routes.draw do
  devise_for :users

  resources :composteurs do
    member do
      post :send_email
    end
  end

  root to: "composteurs#index"

  resources :demandes
  resources :notifications

  resources :donverts
end
