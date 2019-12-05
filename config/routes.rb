Rails.application.routes.draw do
  # get 'donvert/new'
  # get 'donvert/edit'
  # get 'donvert/create'
  # get 'donvert/index'
  devise_for :users


root to: "composteurs#index"

resources :donverts

  resources :composteurs do
    member do
      post :send_email
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
