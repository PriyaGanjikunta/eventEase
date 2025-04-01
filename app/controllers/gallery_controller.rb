class GalleryController < ApplicationController
  before_action :authenticate_user!
    require 'active_merchant'
  
    def index
      @event_gallery = Event.all
    end
  
    def checkout
      amount_to_charge = (session[:amount].to_f * 100).to_i  # Convert to cents
  
      if request.post?
        ActiveMerchant::Billing::Base.mode = :test
        
        # Create a credit card object
        credit_card = ActiveMerchant::Billing::CreditCard.new(
          first_name: params[:name].split.first,
          last_name: params[:name].split.last || '',
          number: params[:credit_no].to_s,
          month: params[:check][:month].to_i,
          year: params[:check][:year].to_i,
          verification_value: params[:verification_number].to_i
        )
  
        if credit_card.valid?
          gateway = ActiveMerchant::Billing::BogusGateway.new  # Use BogusGateway for testing
  
          response = gateway.authorize(amount_to_charge, credit_card)
          puts "✅ DEBUG: Response - #{response.inspect}"  # Debugging output
  
          if response.success?
            gateway.capture(amount_to_charge, response.authorization)  # Capture the payment
  
            # ✅ Update event registrations after payment success
            @event_registrations = current_user.event_registrations.where(status: "pending")
            if @event_registrations.any?
              @event_registrations.update_all(status: "initial payment done")  # Update all pending registrations
            end
  
            session[:cart_id] = nil
            session[:amount] = nil
  
             # ✅ Send Initial Payment Confirmation Email
            PaymentMailer.payment_success_mailer(current_user, @event_registrations, "Initial Payment", amount_to_charge / 100).deliver_now  


            flash[:notice] = "Payment successful! Initial payment done."
            redirect_to :action=>:purchase_complete
          else
            flash[:alert] = "Payment failed: #{response.message}"
            render :checkout, status: :unprocessable_entity
          end
        else
          flash[:alert] = "Invalid credit card details. Please try again."
          render :checkout, status: :unprocessable_entity
        end
      end
    end


    def final_checkout
      @event_registrations = current_user.event_registrations.where(status: "initial payment done")
      
      # ✅ Set default selected event if none is provided
      @selected_registration = if params[:selected_event_id].present?
                                 @event_registrations.find_by(id: params[:selected_event_id])
                               else
                                 @event_registrations.first
                               end
  
      # ✅ Ensure the remaining amount is calculated correctly per event
      @remaining_amount = @selected_registration ? @selected_registration.amount_due - @selected_registration.amount_paid : 0
  
      if request.post?
        amount_to_charge = (@remaining_amount.to_f * 100).to_i  # Convert to cents
  
        ActiveMerchant::Billing::Base.mode = :test
        credit_card = ActiveMerchant::Billing::CreditCard.new(
          first_name: params[:name].split.first,
          last_name: params[:name].split.last || '',
          number: params[:credit_no].to_s,
          month: params[:check][:month].to_i,
          year: params[:check][:year].to_i,
          verification_value: params[:verification_number].to_i
        )
  
        if credit_card.valid?
          gateway = ActiveMerchant::Billing::BogusGateway.new
          response = gateway.authorize(amount_to_charge, credit_card)
  
          if response.success?
            gateway.capture(amount_to_charge, response.authorization)
  
            # ✅ Ensure only the selected event's payment is updated
            selected_registration = @event_registrations.find_by(id: params[:selected_event_id])
  
            if selected_registration
              remaining_amount = selected_registration.amount_due.to_f - selected_registration.amount_paid.to_f
  
              puts "✅ DEBUG: Before Update -> Event ID: #{selected_registration.event_id}, Amount Paid: #{selected_registration.amount_paid}, Remaining: #{remaining_amount}"
  
              selected_registration.update(amount_paid: selected_registration.amount_due, status: "completed")
  
              puts "✅ DEBUG: After Update -> Event ID: #{selected_registration.event_id}, Amount Paid: #{selected_registration.reload.amount_paid}, Status: #{selected_registration.reload.status}"
            else
              flash[:alert] = "Selected event not found for final payment."
              return redirect_to gallery_final_checkout_path
            end
  
            session[:remaining_amount] = nil
  
            # ✅ Send Final Payment Confirmation Email
            PaymentMailer.payment_success_mailer(current_user, [selected_registration], "Final Payment", amount_to_charge / 100).deliver_now  
  
            flash[:notice] = "Final payment successful for #{selected_registration.event.title}!"
            redirect_to :action => :purchase_complete_final
          else
            flash[:alert] = "Payment failed: #{response.message}"
            render :final_checkout, status: :unprocessable_entity
          end
        else
          flash[:alert] = "Invalid credit card details."
          render :final_checkout, status: :unprocessable_entity
        end
      end
    end
  
    def search
    end
  
  
end
