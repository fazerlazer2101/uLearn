class CartController < ApplicationController

  def create
    logger.debug("adding #{params[:id]} to cart")
    course_id = params[:id].to_i
    # Initialises the session
    session[:cart] ||= []
    # Determines if the item is already inside the cart doesn't push it other it does.
    session[:cart] << course_id unless session[:cart].include?(course_id)
    redirect_to root_path
  end

  def delete
    course_id = params[:id].to_i
    session[:cart].delete(course_id)
    redirect_to root_path
  end

  def show
    require 'json'
    @items_in_cart = session[:cart]
    @test ||= [];
    @total_price = 0;
    @items_in_cart.each do |n|
      @test << Course.find(n)
      @total_price += Course.find(n).price
    end






  end

  #Stripe Checkout
  def checkout
    require "stripe"

    # This is your test secret API key.
    Stripe.api_key = 'sk_test_51OJgI5B7ve0qtzXwoCzhLYuz85Z3slLN6cw4LQzTKTd8jTvi3n1DGSH2kYho9jj4yUYU3GttVjYWi2SLvIQrANDV00wDFRYC0X'


    domain = 'http://localhost:3000'

    post '/create-checkout-session' do
      content_type 'application/json'

      session = Stripe::Checkout::Session.create({
        line_items: [{
          # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
          price: '{{PRICE_ID}}',
          quantity: 1,
        }],
        mode: 'payment',
        success_url: domain + '/success.html',
        cancel_url: domain + '/cancel.html',
      })
      redirect session.url, 303
    end

  end
end
