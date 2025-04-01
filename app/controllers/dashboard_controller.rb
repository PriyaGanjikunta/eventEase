class DashboardController < ApplicationController
  before_action :authenticate_user!  # Ensure only logged-in users can access

  def index
    @events = Event.all  # Fetch all events
    @registrations = Registration.includes(:user, :event).all  # Fetch all registrations
  end
end

