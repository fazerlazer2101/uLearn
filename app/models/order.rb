class Order < ApplicationRecord
  belongs_to :customer_info
  has_many :courses_in_order, dependent: :destroy
  validates :customer_info_id,	:stripe_session_id, :order_date,	:price,	:GST,	:HST,	:PST, presence: true
  validates :GST, :HST, :PST, numericality: true
  validates :customer_info_id, numericality: { only_integer: true }
end