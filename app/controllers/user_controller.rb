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
  end
end
