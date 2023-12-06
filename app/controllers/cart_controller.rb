class CartController < ApplicationController
  before_action :authenticate_user!
  helper_method :current_user
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
    require 'stripe'

    @currentUser = current_user

    #Customer info
    @customerInfo = CustomerInfo.find_by(user_id: @currentUser.id)

    @items_in_cart = session[:cart]
    @test ||= [];
    @subtotal_price = 0;
    @items_in_cart.each do |n|
      @test << Course.find(n)
      @subtotal_price += Course.find(n).price
    end
    if !CustomerInfo.find_by(user_id: @currentUser.id).nil?
      @gst_in_dollars = (@subtotal_price * Province.find_by(id:@customerInfo.province_id).GST)
      @pst_in_dollars = (@subtotal_price * Province.find_by(id:@customerInfo.province_id).PST)
      @hst_in_dollars = (@subtotal_price * Province.find_by(id:@customerInfo.province_id).HST)
      @total_price = @subtotal_price + @hst_in_dollars

    end

    #ALL STRIPE BELOW

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
      customer: User.find(@userSession.id).stripe_customer_id,
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
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
      ui_mode: 'hosted',

    )
  end

  def addRegion
    info = CustomerInfo.create(
        address:       params[:address],
        user_id:       params[:id],
        province_id:   params[:province_id]
      )
      flash[:success]= "Successfully updated user information!"
  end
end
