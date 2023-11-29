ActiveAdmin.register Course do

  permit_params :course_title, :description, :price, :number_of_lectures, :difficulty_id,
                :course_length, :category_id, :publish_date
end
