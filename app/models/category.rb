class Category < ApplicationRecord
  has_many :courses, dependent: :destroy
  validates :category_name, presence: true
end
