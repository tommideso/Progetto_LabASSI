class ChangeTipoPastoToIntegerInReservations < ActiveRecord::Migration[7.2]
  def change
    change_column :reservations, :tipo_pasto, :integer, using: 'tipo_pasto::integer'
  end
end
