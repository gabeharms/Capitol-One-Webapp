class CreateTicketCatagories < ActiveRecord::Migration
  def change
    create_table :ticket_catagories do |t|
      t.string "name", :limit => 25

      t.timestamps null: false
    end
  end
end
