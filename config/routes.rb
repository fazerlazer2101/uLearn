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

  #Routes for cart
  post "/cart/:id/update", to: "cart#create"
  post "/cart/:id/delete", to: "cart#delete"
  post "/cart/:id/addRegion", to: "cart#addRegion"
  get "/cart", to: "cart#show"

  #Stripe stuff
  scope "cart/checkout" do
    post "create", to: "checkout#create", as: "checkout_create"
    get "success", to: "checkout#success", as: "checkout_success"
    get "cancel", to: "checkout#cancel", as: "checkout_cancel"
  end

  get "/user/:id", to: "user#show"
  resources :customer_infos, only: %i[show]
end
