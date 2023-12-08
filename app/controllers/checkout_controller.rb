class CheckoutController < ApplicationController
  helper_method :current_user
  before_action :authenticate_user!
  #Establish connection to stripe
  def create
    require 'stripe'
    require 'json'
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

    Stripe.api_key = "sk_test_51OJgI5B7ve0qtzXwoCzhLYuz85Z3slLN6cw4LQzTKTd8jTvi3n1DGSH2kYho9jj4yUYU3GttVjYWi2SLvIQrANDV00wDFRYC0X"

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

    puts(@session.url)
    redirect_to @session.url, allow_other_host: true

  end


  def success
    #Successful payment

    #Updates the orders table
    #Retrieves session id
    session_id = params[:session_id]

    @currentUser = current_user

    #Gets current total and taxes
    #Grabs cart items
    @items_in_cart = session[:cart]
    puts (@items_in_cart)
    @products ||= [];
    @total_price = 0;
    @items_in_cart.each do |n|
      @products << Course.find(n)
      @total_price += Course.find(n).price
      puts (@products)
      puts(Course.find(n).price)
    end

    @province = Province.find(CustomerInfo.find_by("user_id = #{@currentUser.id}").province_id)
    #Creates a new order entry
    newOrder = Order.create(
      customer_info_id: (CustomerInfo.find_by(user_id: @currentUser.id).id).to_i,
      stripe_session_id: (session_id.to_s),
      order_date: Time.current.strftime("%Y-%m-%d %H:%M:%S"),
      price: @total_price,
      GST: @province.GST,
      HST: @province.HST,
      PST: @province.PST
    )

    #Add Products to the purchased_courses table
    @products.each do |n|
      purchased_courses = PurchasedCourse.create(
        course_title: n.course_title.to_s,
        description: n.description.to_s,
        price: n.price,
        number_of_lectures: n.number_of_lectures.to_i,
        difficulty_id: n.difficulty_id.to_i,
        course_length: n.course_length,
        category_id: n.category_id,
        publish_date: n.publish_date,
        users_id: @currentUser.id.to_i
      )
      puts(@currentUser.id)
      puts (purchased_courses.valid?)
    end

    #Add the purchased courses into courses_in_order
    @products.each do |n|
      purchased_in_courses = CoursesInOrder.create(
        order_id: Order.find_by(stripe_session_id: session_id).id,
        purchased_course_id: PurchasedCourse.find_by(course_title: n.course_title).id
      )
    end

    #Deletes cart
    session.delete(:cart)
    redirect_to root_path, allow_other_host:true

  end

  def cancel
    #Cancel the current checkout proccess

    redirect_to root_path, allow_other_host:true
  end
end
