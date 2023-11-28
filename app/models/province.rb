class Province < ApplicationRecord
  has_many :customer_infos
  validates :Province_Name, :founded, presence: true
end
