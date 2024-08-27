class AddOmniauthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
