class OrderDetailsController < ApplicationController
  def show
    #Order id
    @orderId = params[:id]

    #Get tax rates
    @currentPrder = Order.find(@orderId)



  end
end
