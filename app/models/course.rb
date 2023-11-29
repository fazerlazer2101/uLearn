class Course < ApplicationRecord
  belongs_to :difficulty
  belongs_to :category
  validates :course_title, :price, :difficulty_id, :category_id, presence:true
end
