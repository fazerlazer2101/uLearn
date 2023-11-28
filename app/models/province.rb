class Province < ApplicationRecord
  has_many :customer_infos, dependent: :destroy
  validates :Province_Name, presence: true
end
