Rails.application.routes.draw do



  get 'cars/checkout'
  get 'cars/purchase_complete'
  post 'cars/checkout'

  get 'cars/search'
  post 'cars/search'




  resources :line_items
  resources :carts
  resources :cars
  devise_for :users, controller: {
    registrations: 'registrations'
  }

  get "sign_up",to: "adminregistrations#new"
  post "sign_up",to: "adminregistrations#create"

  delete "logout", to: "sessions#destroy"

  get "sign_in",to: "sessions#new"
  post "sign_in",to: "sessions#create"

  
  
  
  root 'cars#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
