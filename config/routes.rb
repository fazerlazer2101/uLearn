Rails.application.routes.draw do
  get 'courses/show'
  # Routes for Course (Home)
  root to: "home#index"

  # Routes for User
  get "user/show"
  devise_for :users
  post "/user/:id/update", to: "user#update"
  get "/user/:id", to: "user#show"
  resources :customer_infos, only: %i[show]
end
