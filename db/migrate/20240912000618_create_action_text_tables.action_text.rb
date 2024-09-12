# This migration comes from action_text (originally 20180528164100)
class CreateActionTextTables < ActiveRecord::Migration[6.0]
  def change
    unless table_exists?(:action_text_rich_texts)
      create_table :action_text_rich_texts do |t|
        t.string :name, null: false
        t.string :record_type, null: false
        t.bigint :record_id, null: false
        t.bigint :blob_id, null: false
        t.datetime :created_at, null: false
        t.index [:blob_id], name: "index_action_text_rich_texts_on_blob_id"
        t.index [:record_type, :record_id, :name, :blob_id], name: "index_action_text_rich_texts_uniqueness", unique: true
      end
    end
  end


  private
    def primary_and_foreign_key_types
      config = Rails.configuration.generators
      setting = config.options[config.orm][:primary_key_type]
      primary_key_type = setting || :primary_key
      foreign_key_type = setting || :bigint
      [ primary_key_type, foreign_key_type ]
    end
end
