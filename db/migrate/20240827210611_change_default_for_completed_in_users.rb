class ChangeDefaultForCompletedInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :completed, 0
  end
end