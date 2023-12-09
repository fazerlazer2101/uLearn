class AddUserIdToPurchasedCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :purchased_courses, :users, index: true
  end
end
