class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.text :title
      t.references :customer, index: true
      t.references :employee, index: true
      t.boolean :complete

      t.timestamps null: false
    end
    add_foreign_key :tickets, :customers
    add_foreign_key :tickets, :employees
    add_index :tickets, [:customer_id, :employee_id, :created_at]
  end
end
