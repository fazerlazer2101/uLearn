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
      puts (@products)
    end

    @userSession = current_user

    @province = Province.find(CustomerInfo.find_by(user_id: @userSession.id).province_id)
    #Formats it into proper json
    @productlist = @products.map do |u|
      {:price_data =>{ :currency => "cad", :product_data => {:name => u.course_title}, :unit_amount => (u.price * 100).to_i }, :quantity => 1 }
    end
    #Adds HST to productlist
    @productlist << {:price_data =>{ :currency => "cad", :product_data => {:name => "HST", :description => "GST + PST"}, :unit_amount => ((@province.HST *  @total_price)*100).to_i }, :quantity => 1}

    #Transforms it as json
    json_data = @productlist.as_json
    puts json_data
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
      mode: 'payment',
      phone_number_collection: {
        "enabled": true
      },
      shipping_address_collection: {
      allowed_countries: ['CA'],
      },
      billing_address_collection: "required",




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
