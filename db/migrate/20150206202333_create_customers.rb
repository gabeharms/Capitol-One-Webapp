class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      
      t.string :first_name
      t.string :last_name, index: true
      
      t.string :email, index: true
      
      t.string :password_digest

      t.timestamps null: false
    end
  end
  
end
