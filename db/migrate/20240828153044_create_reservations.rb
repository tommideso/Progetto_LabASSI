class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.date :data_prenotazione # Data della prenotazione

      t.string :stato # Stato della prenotazione (es. pending, confirmed, cancelled)
      t.decimal :prezzo, precision: 10, scale: 2 # Prezzo della prenotazione
      t.integer :num_persone # Numero di persone
      t.string :tipo_pasto # pranzo o cena 
      t.jsonb :extra # Eventuali extra inclusi nella prenotazione
      t.text :modifiche_richieste # Modifiche richieste dal cliente
      t.string :indirizzo_consegna # Indirizzo di consegna
      t.integer :recensione_cliente  # Recensione che chef da al cliente (da 1 a 5, ad esempio)
      t.boolean :pagamento_effettuato, default: false # Pagamento effettuato
      t.boolean :rimborsato, default: false # Rimborsato

      t.timestamps
    end
    # Aggiungi un indice unico sulla combinazione di user_id e data_prenotazione
    add_index :reservations, [:user_id, :data_prenotazione], unique: true
  end
end
