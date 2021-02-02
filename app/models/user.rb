class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :authored_projects, class_name: 'Project', foreign_key: :author_id
  has_many :authored_tasks, class_name: "Task", foreign_key: :author_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
