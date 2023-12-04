Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://checkout.stripe.com/c/pay/'
    resource '*', headers: :any, methods: [:get, :post]
  end
end