class RemoveInizializzato < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :inizializzato
    change_column_default :users, :completed, nil
  end
end
