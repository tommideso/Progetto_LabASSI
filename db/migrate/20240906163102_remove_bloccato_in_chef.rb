class RemoveBloccatoInChef < ActiveRecord::Migration[7.2]
  def change
    remove_column :chefs, :bloccato, :boolean
  end
end
