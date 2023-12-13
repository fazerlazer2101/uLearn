class CoursesInOrder < ApplicationRecord
  belongs_to :order
  has_many :purchased_course, dependent: :destroy
  validates :order_id, :purchased_course_id, numericality: { only_integer: true }
end
