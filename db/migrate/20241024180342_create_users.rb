class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name , null: false
      t.string :email, null: false
      t.integer :user_type, null: false
      t.string :country, null: false

      t.timestamps
    end
    # Adding a unique index on the email column
    add_index :users, :email, unique: true
  end
end
