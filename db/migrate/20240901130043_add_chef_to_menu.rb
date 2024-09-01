class AddChefToMenu < ActiveRecord::Migration[7.2]
  def change
    add_reference :menus, :chef, foreign_key: { to_table: :chefs }
  end
end

  