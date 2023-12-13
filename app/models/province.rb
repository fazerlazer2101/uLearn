class Province < ApplicationRecord
  has_many :customer_infos, dependent: :destroy
  validates :Province_Name,:GST, :HST, :PST, presence: true
  validates :GST, :HST, :PST, numericality: true
end
