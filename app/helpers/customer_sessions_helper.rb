module CustomerSessionsHelper
  
   
  
   # Returns the current logged-in user (if any).
  def current_customer
    @current_customer ||= Customer.find_by(id: session[:customer_id])
  end
  
  # Returns true if the user is logged in, false otherwise.
  def customer_logged_in?
    !current_customer.nil?
  end
  
   # Logs in the given user.
  def customer_log_in(customer)
    session[:customer_id] = customer.id
  end
  
  # Returns true if the given user is the current user.
  def current_customer?(customer)
    customer == current_customer
  end
  
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
