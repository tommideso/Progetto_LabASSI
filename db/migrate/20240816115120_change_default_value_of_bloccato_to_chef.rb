class ChangeDefaultValueOfBloccatoToChef < ActiveRecord::Migration[7.2]
  def change
    change_column_default :chefs, :bloccato, false
  end
end
