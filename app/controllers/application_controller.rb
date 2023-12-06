class ApplicationController < ActionController::Base
  after_action :allow_all_origins

  def allow_all_origins
    response.headers['Access-Control-Allow-Origin'] = 'https://checkout.stripe.com', 'http://localhost:3000/'
  end
end