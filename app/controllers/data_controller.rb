class DataController < ApplicationController
  before_action :authenticate_user!

  def registered_users
    if current_user.role == "organizer"
      @event_registrations = EventRegistration
                             .where(organizer_id: current_user.id)  # Fetch only this organizer's assigned registrations
                             .includes(:user, :event)
    else
      flash[:alert] = "You are not authorized to view this page."
      redirect_to root_path
    end
  end
end


  
