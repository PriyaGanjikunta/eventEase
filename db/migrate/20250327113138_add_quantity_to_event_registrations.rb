class AddQuantityToEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :event_registrations, :quantity, :integer
  end
end
