class UserController < ApplicationController
  helper_method :current_user
  def show
    @Province = Province.all
    # Retrieve current user info
    @currentUserInformation = CustomerInfo.find_by(user_id: params[:id])
  end

  def update
    @currentUser = CustomerInfo.find_by(user_id: params[:id])
    if !@currentUser.nil?
      @currentUser.update(
        customer_name: params[:fullName],
        phone_number:  params[:phone],
        address:       params[:address],
        province_id:   params[:province_id]
      )
      puts("updates")
    else
      info = CustomerInfo.create(
        customer_name: params[:fullName],
        phone_number:  params[:phone],
        address:       params[:address],
        user_id:       params[:id],
        province_id:   params[:province_id]
      )
      puts("creates")
    end
  end
end
