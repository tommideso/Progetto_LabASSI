class ChangeDefaultValueToDisattivatoOfMenu < ActiveRecord::Migration[7.2]
  def change
    change_column_default :menus, :disattivato, false
  end
end
