class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      
      t.text :title
      
      t.references :customer, index: true
      t.references :employee, index: true
      
      t.references :ticket_category, index: true
      t.references :ticket_statuses,  index: true
      

      t.timestamps null: false
    end

    add_index :tickets, :created_at
  end
end
