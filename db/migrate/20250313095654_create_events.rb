class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.string :location
      t.integer :organizer_id

      t.timestamps
    end
  end
end
