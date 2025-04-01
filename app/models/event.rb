class Event < ApplicationRecord

    belongs_to :organizer, class_name: "User", foreign_key: "organizer_id"
    has_many :registrations, dependent: :destroy
    has_one_attached :event_image
    has_many :event_registrations, dependent: :destroy
end

  
