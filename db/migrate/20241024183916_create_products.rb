class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :product_type

      t.timestamps
    end

    # Adding a unique index on the name column
    add_index :products, :name, unique: true
  end
end
