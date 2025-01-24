class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :account_type
      t.decimal :balance, precision: 10, scale: 2, default: 0.00
      t.string :account_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :accounts, :account_number, unique: true
  end
end
