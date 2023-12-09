class Difficulty < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_many :purchased_course, dependent: :destroy

  validates :difficulty, presence: true
end
