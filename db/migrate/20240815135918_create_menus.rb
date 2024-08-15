class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus do |t|
      t.string :titolo
      t.text :descrizione
      t.decimal :prezzo_persona
      t.integer :min_persone
      t.integer :max_persone
      t.string :tipo_cucina
      t.jsonb :allergeni
      t.jsonb :preferenze_alimentari
      t.jsonb :adattabile
      t.jsonb :extra
      t.decimal :prezzo_extra
      t.boolean :disattivato

      t.timestamps
    end
  end
end
