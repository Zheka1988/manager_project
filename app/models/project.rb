class Project < ApplicationRecord
  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 200 }
end
