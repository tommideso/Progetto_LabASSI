class AddStripeExtraToMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :menus, :stripe_vino_price_id, :string
    add_column :menus, :stripe_miseenplace_price_id, :string
  end
end
