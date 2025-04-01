class AddDefaultStatusToEventRegistrations < ActiveRecord::Migration[7.1]
  def up
    change_column_default :event_registrations, :status, "pending"
    EventRegistration.where(status: nil).update_all(status: "pending")
  end

  def down
    change_column_default :event_registrations, :status, nil
  end
end
