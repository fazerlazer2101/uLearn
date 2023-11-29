Rails.application.routes.draw do
  # Routes for Course (Home)
  root to: "home#index"
  # get 'courses/show'
  resources :courses, only: %i[show]

  # Routes for User
  get "user/show"
  devise_for :users
  post "/user/:id/update", to: "user#update"
  get "/user/:id", to: "user#show"
  resources :customer_infos, only: %i[show]
end
