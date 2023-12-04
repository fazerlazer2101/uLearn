class CheckoutController < ApplicationController

  #Establish connection to stripe
  def create

    #Test only use one product
    course = Course.find(3)
    course2 = Course.find(1)
    province = Province.find(1)

    #Redirect to homepage if no product is found
    if(course.nil?)
      redirect_to root_path
    end

    #Create Stripe session
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      line_items: [
        {
          price_data: {
            currency: "cad",
            product_data: {
              name: course.course_title,
            },
            unit_amount: 20000,
          },

          quantity: 1,
          price_data: {
            currency: "cad",
            product_data: {
              name: course2.course_title,
            },
            unit_amount: course.price.to_i,
          },
          quantity: 1

        }
      ],
      mode: 'payment'
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
