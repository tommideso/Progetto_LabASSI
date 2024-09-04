class AddStripeSessionIdToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :stripe_session_id, :string
  end
end
