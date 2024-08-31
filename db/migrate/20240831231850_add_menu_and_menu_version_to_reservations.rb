class AddMenuAndMenuVersionToReservations < ActiveRecord::Migration[6.1]
  def change
    add_reference :reservations, :menu, foreign_key: true
    add_reference :reservations, :menu_version, foreign_key: { to_table: :versions }
  end
end