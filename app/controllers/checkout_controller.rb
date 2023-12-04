class CheckoutController < ApplicationController

  #Establish connection to stripe
  def create
    require 'json'
    #Grabs cart items
    @items_in_cart = session[:cart]
    @products ||= [];
    @items_in_cart.each do |n|
      @test << Course.find(n)
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


    #Create Stripe session
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      line_items: [json_data],
      mode: 'payment'
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
