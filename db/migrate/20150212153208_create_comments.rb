class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      
      t.references :ticket,   index: true
      t.references :employee, index: true
      t.boolean   :initiator   # 0 for customer, 1 for employee
      t.text      :comment,   index: true
      
      t.timestamps null: false
    end
    add_index :comments, :created_at
  end
end
