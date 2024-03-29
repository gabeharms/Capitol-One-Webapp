class CreateAhoyEvents < ActiveRecord::Migration
  def change
    create_table :ahoy_events, id: false do |t|
      t.string :id, primary_key: true
      t.uuid :visit_id

      # user
      # add t.string :user_type if polymorphic

      t.string :name
      t.text :properties
      t.timestamp :time
    end

    add_index :ahoy_events, [:visit_id]
    add_index :ahoy_events, [:time]
  end
end
