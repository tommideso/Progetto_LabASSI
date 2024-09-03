class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.integer :valutazione
      t.text :commento
      t.references :tipo_recensione, polymorphic: true, null: false
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
