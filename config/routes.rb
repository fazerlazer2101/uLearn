Rails.application.routes.draw do
  # Routes for Category
  resources :categories, only: %i[index show]

  # Routes for Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Routes for Course (main content)
  root to: "courses#index"
  get "courses/about"
  resources :courses, only: %i[index show]

  # Routes for User
  get "user/show"
  devise_for :users
  post "/user/:id/update", to: "user#update"
  get "/user/:id", to: "user#show"
  resources :customer_infos, only: %i[show]

  # Routes for Cart management
  post "/cart/:id/update", to: "cart#create"
  post "/cart/:id/delete", to: "cart#delete"
  post "/cart/:id/addRegion", to: "cart#addRegion"
  get "/cart", to: "cart#show"

  # Routes for Stripe
  scope "cart/checkout" do
    post "create", to: "checkout#create", as: "checkout_create"
    get "success", to: "checkout#success", as: "checkout_success"
    get "cancel", to: "checkout#cancel", as: "checkout_cancel"
  end

end
