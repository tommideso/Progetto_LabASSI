class AddDisattivatoDaToMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :menus, :disattivato_da, :string
  end
end
