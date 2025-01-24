class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :destination_account, null: true, foreign_key: { to_table: :accounts }
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :transaction_type, null: false
      t.string :description, null: false
      t.string :status, default: 'completed'

      t.timestamps
    end
  end
end
