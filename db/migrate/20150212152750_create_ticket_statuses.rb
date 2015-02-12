class CreateTicketStatuses < ActiveRecord::Migration
  def change
    create_table :ticket_statuses do |t|
      t.string "status", :limit => 25
      
      t.timestamps null: false
    end
  end
end
