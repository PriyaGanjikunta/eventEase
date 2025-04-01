class ChangeQuantityInRegistrations < ActiveRecord::Migration[7.1]
  def change
    change_column :registrations, :quantity, :integer, null: false, default: 1
  end
end
