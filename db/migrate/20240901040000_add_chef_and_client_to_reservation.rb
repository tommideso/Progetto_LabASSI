class AddChefAndClientToReservation < ActiveRecord::Migration[7.2]
  def change
    # Aggiungi riferimento a chef e client
    add_reference :reservations, :chef, foreign_key: { to_table: :chefs }
    add_reference :reservations, :client, foreign_key: { to_table: :clients }

    # Rimuovi riferimento a user
    remove_reference :reservations, :user, index: true, foreign_key: true
  end
end
