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


  end

  def addRegion
    info = CustomerInfo.create(
        address:       params[:address],
        user_id:       params[:id],
        province_id:   params[:province_id]
      )
      #Updates information on stripe
  Stripe::Customer.update(
    User.find(current_user.id).stripe_customer_id.to_s,
    {
      phone: "1#{params[:phone].to_s}",
      name: params[:fullName].to_s,
      address: {
        country: 'CA',
        line1: params[:address].to_s,
        state: Province.find(params[:province_id]).Province_Name.to_s,
      },
      shipping: {
        address: {
          country: 'CA',
          line1:  params[:address].to_s,
          state: Province.find(params[:province_id]).Province_Name.to_s,
        },
        name: params[:fullName].to_s,
        phone: "1#{params[:phone].to_s}",
      },
    },
  )
      flash[:success]= "Successfully updated user information!"
      redirect_to cart_path
  end
end
