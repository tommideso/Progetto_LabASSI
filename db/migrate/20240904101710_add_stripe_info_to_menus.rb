class AddStripeInfoToMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :menus, :stripe_price_id, :string
    add_column :menus, :stripe_product_id, :string
  end
end
