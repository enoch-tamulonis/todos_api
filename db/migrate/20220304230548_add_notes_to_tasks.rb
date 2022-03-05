class AddNotesToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :notes, :text
  end
end
