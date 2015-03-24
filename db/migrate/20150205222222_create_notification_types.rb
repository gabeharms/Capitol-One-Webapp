class CreateNotificationTypes < ActiveRecord::Migration
  def change
    create_table :notification_types do |t|
      t.string "notifications", :limit=>25
      
      t.timestamps null: false
    end
  end
end
