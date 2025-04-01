class AddOrganizerIdToEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :event_registrations, :organizer_id, :integer
  end
end
