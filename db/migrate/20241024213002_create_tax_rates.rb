class CreateTaxRates < ActiveRecord::Migration[7.2]
  def change
    create_table :tax_rates do |t|
      t.string :country
      t.integer :product_type, null: false
      t.decimal :vat_rate

      t.timestamps
    end

    # Adding a unique index on country and product_type to prevent duplicates
    add_index :tax_rates, [ :country, :product_type ], unique: true
  end
end
