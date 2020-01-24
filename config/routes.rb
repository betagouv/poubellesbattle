Rails.application.routes.draw do
  devise_for :users
  # get 'users/:id' => 'users#show'

  resources :demandes

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
