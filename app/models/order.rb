class Order < ApplicationRecord
  belongs_to :customer_info
  has_many :courses_in_order
end