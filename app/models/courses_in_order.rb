class CoursesInOrder < ApplicationRecord
  belongs_to :order
  belongs_to :purchased_course
end
