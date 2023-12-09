class OrderDetailsController < ApplicationController
  def show
    #Order id
    @orderId = params[:id]

    @orderName = Order.find(@orderId).stripe_session_id

    #Get tax rates
    @currentorder = Order.find(@orderId)

    arrayOfCourseid ||=[]
    #Get all courses in this order
    @coursesInOrder = CoursesInOrder.all.where(order_id: @orderId)
    @coursesInOrder.each  do |course|
      arrayOfCourseid << course.purchased_course_id

    end

    @courses = PurchasedCourse.find(arrayOfCourseid)


  end
end
