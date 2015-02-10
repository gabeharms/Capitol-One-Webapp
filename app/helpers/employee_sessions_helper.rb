module EmployeeSessionsHelper
  
  # Returns the current logged-in user (if any).
  def current_employee
    @current_employee ||= Employee.find_by(id: session[:employee_id])
  end
  
  # Returns true if the user is logged in, false otherwise.
  def employee_logged_in?
    !current_employee.nil?
  end
  
   # Logs in the given user.
  def employee_log_in(employee)
    session[:employee_id] = employee.id
  end
  
  # Returns true if the given user is the current user.
  def current_employee?(employee)
    employee == current_user
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
