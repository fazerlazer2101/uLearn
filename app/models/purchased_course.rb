class PurchasedCourse < ApplicationRecord
  belongs_to :difficulty
  belongs_to :category
  belongs_to :courses_in_order
end
