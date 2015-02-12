class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      
      t.string "first_name", :limit => 25
      t.string "last_name",  :limit => 50
      t.string "email",      :default => "", :null => false
      t.string :password_digest
      
      t.timestamps null: false
    end
    add_index("customers", "last_name")
    add_index("customers", "email")
  end
end
