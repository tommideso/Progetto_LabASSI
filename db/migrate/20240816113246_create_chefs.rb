class CreateChefs < ActiveRecord::Migration[7.2]
  def change
    create_table :chefs do |t|
      t.string :indirizzo
      t.string :telefono
      t.integer :raggio
      t.text :descrizione
      t.boolean :bloccato
      # aggiungo index: { unique: true } per evitare duplicati in user (per un'istanza non ci possono essere 2 riferimenti)
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
