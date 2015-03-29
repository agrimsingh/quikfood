class AddAccountTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_type, :boolean
  end
end
