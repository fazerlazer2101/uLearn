class CustomerInfo < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :orders , dependent: :destroy
end
