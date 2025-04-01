class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :payment, optional: true  # Payment may not exist at the time of registration

  validates :date, presence: true
  validates :time, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end



