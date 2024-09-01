class CreateVersionImages < ActiveRecord::Migration[7.2]
  def change
    create_table :version_images do |t|
      t.references :version, null: false, foreign_key: true

      t.timestamps
    end
  end
end
