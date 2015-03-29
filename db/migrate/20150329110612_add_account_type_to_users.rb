class AddAccountTypeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :account_type, :string
  end

  def down
    remove_column :users, :account_type
  end
end
