class CartController < ApplicationController
  def create
    logger.debug("adding #{params[:id]} to cart")
    courseId = params[:id].to_i

    session[:cart] << courseId unless session[:cart].include?(courseId)
    redirect_to root_path
  end
end
