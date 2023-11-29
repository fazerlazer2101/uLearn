Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "user/show"
  devise_for :users
  get "homepage/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # When update post request is recieved
  post "/user/:id/update", to: "user#update"

  get "/user/:id", to: "user#show"
  root "homepage#index"

  resources :customer_infos, only: %i[show]
end
