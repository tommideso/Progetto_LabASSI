class ChangeStripeSessionIdToStripePaymentIntentInReservations < ActiveRecord::Migration[7.2]
  def change
    rename_column :reservations, :stripe_session_id, :stripe_payment_intent_id
  end
end
