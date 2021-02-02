class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  
  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 200 }

end
