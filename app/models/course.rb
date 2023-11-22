class Course < ApplicationRecord
  belongs_to :difficulty
  belongs_to :category
end
