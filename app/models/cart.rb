class Cart < ApplicationRecord
    has_many :line_items, dependent: :destroy
    belongs_to :user, optional: true  # A cart belongs to a user (optional for guest users)

    def add_product(event_id)
        current_item = line_items.find_by(event_id: event_id) # 🔹 Use event_id instead of store_id
    
        if current_item
          current_item.quantity = (current_item.quantity || 0) + 1 # 🔹 Ensure quantity is not nil
        else
          current_item = line_items.build(event_id: event_id, quantity: 1) # 🔹 Set default quantity
        end
        current_item
    end
    
    def total_price
        line_items.to_a.sum { |item| item.total_price }
    end 
end
