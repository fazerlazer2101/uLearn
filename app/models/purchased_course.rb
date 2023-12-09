class PurchasedCourse < ApplicationRecord
  belongs_to :difficulty
  belongs_to :category
  has_one :courses_in_order

  validates :course_title, :price, :number_of_lectures, :difficulty_id,	:course_length,	:category_id,	:publish_date, presence: true
  validates :price, numericality: true
  validates :difficulty_id, :category_id, numericality: { only_integer: true }
end
