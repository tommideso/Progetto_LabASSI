class AddInitializationColumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :inizializzato, :boolean
  end
end
