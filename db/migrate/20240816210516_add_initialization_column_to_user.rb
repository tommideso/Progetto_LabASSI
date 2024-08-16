class AddInitializationColumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :initializzato, :boolean
  end
end
