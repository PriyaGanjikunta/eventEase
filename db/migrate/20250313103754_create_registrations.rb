class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations do |t|
      t.date :date, null: false
      t.time :time, null: false
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :payment, null: false, foreign_key: true

      t.timestamps
    end
  end
end


