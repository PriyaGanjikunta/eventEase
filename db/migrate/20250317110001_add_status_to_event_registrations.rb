class AddStatusToEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :event_registrations, :status, :string
  end
end
