class EmployeeSessionsController < ApplicationController
  
  
  def new
  end
  
  def create
    employee = Employee.find_by(email: params[:session][:email].downcase)
    if employee && employee.authenticate(params[:session][:password])
      employee_log_in employee
      redirect_back_or employee
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    employee_log_out
    redirect_to root_url
  end
  
  private
    
     # Logs in the given user.
    def employee_log_in(employee)
      session[:employee_id] = employee.id
    end
    
    # Logs out the current user.
    def employee_log_out
      session.delete(:employee_id)
      @current_employee = nil
    end
    
     # Returns the current logged-in user (if any).
    def current_employee
      @current_employee ||= employee.find_by(id: session[:employee_id])
    end
end
