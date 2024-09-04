class ChangeStatoToEnumInReservations < ActiveRecord::Migration[7.2]
  def change
    # Cambia il tipo di colonna da stringa a integer
    change_column :reservations, :stato, :integer, using: 'stato::integer', default: 0, null: false
  end
end