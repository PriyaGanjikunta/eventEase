class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :organizer, class_name: "User", foreign_key: "organizer_id", optional: true

   # Set default status to 'pending' when a new record is created
   after_initialize :set_default_status, if: :new_record?
  
   def set_default_status
     self.status ||= "pending"
   end
end
