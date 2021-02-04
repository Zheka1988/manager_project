# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.text :body
      t.integer :priority
      t.datetime :deadline
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
