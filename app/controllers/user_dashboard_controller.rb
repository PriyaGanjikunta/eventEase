class UserDashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_registrations = current_user.event_registrations.includes(:event)

  end
end
