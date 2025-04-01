class LineItem < ApplicationRecord
  belongs_to :cart
  belongs_to :event
  has_one_attached :event_image

  def total_price
    event.price * self.quantity
  end
end
