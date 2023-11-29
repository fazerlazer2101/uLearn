Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Routes for Course (Home)
  root to: "home#index"
  get "home/about"
  resources :courses, only: %i[show]

  # Routes for User
  get "user/show"
  devise_for :users
  post "/user/:id/update", to: "user#update"
  get "/user/:id", to: "user#show"
  resources :customer_infos, only: %i[show]
end
