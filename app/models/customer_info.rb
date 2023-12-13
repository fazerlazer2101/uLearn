class CustomerInfo < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :orders , dependent: :destroy

  validates :user_id, :province_id, numericality: { only_integer: true }
end
