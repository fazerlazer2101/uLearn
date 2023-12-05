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
      flash[:success]= "Successfully updated user information!"
  end
end
