class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 200 }

end
