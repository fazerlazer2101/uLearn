class PurchasedCourse < ApplicationRecord
  belongs_to :difficulty
  belongs_to :category
  has_one :courses_in_order
end
