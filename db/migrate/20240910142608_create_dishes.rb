class CreateDishes < ActiveRecord::Migration[7.2]
  def change
    create_table :dishes do |t|
      t.string :nome
      t.string :tipo_portata
      t.text :ingredienti
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
