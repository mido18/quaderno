class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :transaction_type, null: false
      t.decimal :tax_applied
      t.datetime :transaction_date
      t.integer :status, null: false

      t.timestamps
    end

    # Adding an index on transaction_date for better query performance
    add_index :transactions, :transaction_date
  end
end
