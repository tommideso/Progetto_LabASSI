class AddLockableToDevise < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :locked_at, :datetime
  end
end