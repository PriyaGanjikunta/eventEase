class PaymentMailer < ApplicationMailer
    default from: 'noreply@eventease.com'
  
    def payment_success_mailer(user, registrations, payment_type, amount)
      @user = user
      @registrations = registrations
      @payment_type = payment_type # "Initial Payment" or "Final Payment"
      @amount = amount
  
      mail(to: @user.email, subject: "#{@payment_type} Confirmation for EventEase")
    end
end


  

