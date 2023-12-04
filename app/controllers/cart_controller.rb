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
    @items_in_cart = session[:cart]
    @test ||= [];
    @total_price = 0;
    @items_in_cart.each do |n|
      @test << Course.find(n)
      @total_price += Course.find(n).price
    end

  end
end
