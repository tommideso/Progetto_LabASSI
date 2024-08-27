class ChangeCompletedToIntegerInUsers < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :completed, :integer, using: 'completed::integer', default: 0
  end

  def down
    change_column :users, :completed, :boolean, using: 'completed::boolean'
  end
end