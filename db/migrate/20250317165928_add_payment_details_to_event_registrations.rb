class AddPaymentDetailsToEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :event_registrations, :amount_due, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :event_registrations, :amount_paid, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
