class CreateEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :event_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.text :user_details
      t.references :organizer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
