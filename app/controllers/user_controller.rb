class UserController < ApplicationController
  helper_method :current_user

  #Flash types
add_flash_types :success
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
      flash[:success]= "Successfully updated user information!"
      redirect_to user_password_path, success: "Successfully updated user information!"
    else
      info = CustomerInfo.create(
        customer_name: params[:fullName],
        phone_number:  params[:phone],
        address:       params[:address],
        user_id:       params[:id],
        province_id:   params[:province_id]
      )
      flash[:success]= "Successfully updated user information!"
      redirect_to user_password_path, success: "Successfully updated user information!"
    end
  end
end
