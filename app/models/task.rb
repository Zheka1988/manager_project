# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true

  def complete_task
    update!(completed: true)
  end
end
