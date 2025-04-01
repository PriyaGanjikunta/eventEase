class AddQuantityToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :quantity, :integer
  end
end
