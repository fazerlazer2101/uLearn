class Course < ApplicationRecord
  belongs_to :difficulty
  belongs_to :category
  validates :course_title, :price, :difficulty_id, :category_id, :publish_date, presence:true
  validates :price, numericality: true
  validates :difficulty_id, :category_id, numericality: { only_integer: true }
end
