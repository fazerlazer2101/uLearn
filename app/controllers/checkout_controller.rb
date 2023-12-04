class CheckoutController < ApplicationController
  helper_method :current_user
  before_action :authenticate_user!
  #Establish connection to stripe
  def create
    require 'json'
    #Grabs cart items
    @items_in_cart = session[:cart]
    @products ||= [];
    @total_price = 0;
    @items_in_cart.each do |n|
      @products << Course.find(n)
      @total_price += Course.find(n).price
    end

    #Formats it into proper json
    @productlist = @products.map do |u|
      {:price_data =>{ :currency => "cad", :product_data => {:name => u.course_title}, :unit_amount => (u.price * 100).to_i }, :quantity => 1 }
    end
    #Transforms it as json
    json_data = @productlist.as_json
    #Redirect to homepage if no product is found
    if(@items_in_cart.nil?)
      redirect_to root_path
    end

    @userSession = current_user

    #Create Stripe session
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      customer_email: @userSession.email,
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      line_items: [json_data],
      mode: 'payment',
      phone_number_collection: {
        "enabled": true
      },
      shipping_address_collection: {
      allowed_countries: ['CA'],
    },
    total_details: {
      amount_tax: 0
    }



    )
    redirect_to @session.url, allow_other_host:true
  end


  def success
    #Successful payment

  end

  def cancel
    #Cancel the current checkout proccess
    redirect_to root_path, allow_other_host:true
  end
end
