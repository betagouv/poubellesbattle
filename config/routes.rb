Rails.application.routes.draw do
  devise_for :users

  # delete "demandes/:id", to: "demandes#destroy", as: "destroy_demande"
  resources :demandes
  # post "demandes/:id", to: "demandes#cancel_planification", as: "cancel_planification"
  resources :notifications

  resources :composteurs do
    member do
      post :send_email
    end
  end

  root to: "composteurs#index"

  resources :donverts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
