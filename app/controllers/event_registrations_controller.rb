class EventRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = Cart.find_by(id: session[:cart_id])
    @cart_items = @cart ? @cart.line_items.includes(event: :organizer) : []
  
    if @cart_items.empty?
      redirect_to gallery_index_path, alert: "Your cart is empty. Please add events before registering."
    end
  
    @organizers = User.where(role: "organizer")  # Fetch all organizers

  end
  
  

  def create
    selected_organizer = User.find(params[:selected_organizer_id])  
    success = true
    total_initial_payment = 0.0  
    total_remaining_payment = 0.0 
  
    @cart = Cart.find_by(id: session[:cart_id])  
    return redirect_to gallery_index_path, alert: "Your cart is empty!" unless @cart
    
    event_registrations_params.each do |event_reg|
      event = Event.find(event_reg[:event_id])  
  
      # ✅ Get quantity from cart (not params)
      cart_item = @cart.line_items.find_by(event_id: event.id)
      quantity = cart_item&.quantity || 1  
  
      registration = current_user.event_registrations.build(event_reg)
      registration.status = "pending"
      registration.quantity = quantity  # ✅ Assign quantity here
  
      total_price = event.price * quantity
      initial_payment = (total_price * 0.4).round(2)
      remaining_amount = (total_price - initial_payment).round(2)
  
      registration.amount_due = total_price  
      registration.amount_paid = initial_payment  
  
      total_initial_payment += initial_payment
      total_remaining_payment += remaining_amount 
  
      unless registration.save
        flash[:alert] = "Registration failed for event: #{event.title}."
        success = false
        break
      end
    end
  
    if success
      session[:amount] = total_initial_payment  
      session[:remaining_amount] = total_remaining_payment  
      session[:cart_id] = nil
      redirect_to gallery_checkout_path, notice: "Registration successful! Proceed to initial payment."
    else
      flash[:alert] = "Please fill in all required details correctly."
      redirect_to new_event_registration_path
    end
  end
  
    
  
  private
  
  def event_registrations_params
    params.require(:event_registrations).map do |event_reg|
      event_reg.permit(:event_id, :date, :time, :user_details, :user_id,:amount_due, :amount_paid, :status, :organizer_id)
    end
  end
  
end

