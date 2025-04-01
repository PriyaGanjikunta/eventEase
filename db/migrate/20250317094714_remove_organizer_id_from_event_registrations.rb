class RemoveOrganizerIdFromEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    remove_column :event_registrations, :organizer_id, :integer
  end
end
