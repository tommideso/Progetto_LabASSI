class RemoveRimborsatoAndPagamentoEffettuatoFromReservations < ActiveRecord::Migration[7.2]
  def change
    remove_column :reservations, :rimborsato, :boolean
    remove_column :reservations, :pagamento_effettuato, :boolean
  end
end
