class AddBitcoinFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :btc_public_key, :string
    add_column :users, :total_btc_received, :decimal
    add_column :users, :total_transactions, :integer
  end
end
