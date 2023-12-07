class CoursesInOrder < ApplicationRecord
  belongs_to :order
  has_many :purchased_course, dependent: :destroy
end
