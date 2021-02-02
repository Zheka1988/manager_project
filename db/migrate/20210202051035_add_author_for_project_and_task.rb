class AddAuthorForProjectAndTask < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :author, foreign_key: { to_table: :users }
    add_reference :tasks, :author, foreign_key: { to_table: :users }
  end
end
