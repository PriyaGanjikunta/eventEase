class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :contact, :role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :contact, :role])
    end

    def after_sign_in_path_for(resource)
      if resource.role == "organizer"
        dashboard_index_path  # Organizers see event management
      else
        gallery_index_path  # Users go to the homepage
      end
    end

    private
    def current_cart
        Cart.find(session[:cart_id])
        rescue ActiveRecord::RecordNotFound
        cart = Cart.create
        session[:cart_id] = cart.id
        cart
    end

    
    
end




  