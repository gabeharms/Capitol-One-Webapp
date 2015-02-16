class EmployeesController < ApplicationController
  before_action :logged_in_employee, only: [:edit, :update, :display_tickets]
  before_action :correct_employee,   only: [:edit, :update]
  
  def new
    @employee = Employee.new
  end

  def show
    @employee = Employee.find(params[:id])
    @tickets = Ticket.paginate(page: params[:page])
  end
  
  def display_tickets
    @employee = current_employee
    @category = TicketCatagory.all
    filter = params[:filter]
    if filter.nil?
      @tickets = Ticket.reorder("tickets.created_at DESC").paginate(page: params[:page])
    elsif filter == '1'
      @tickets = Ticket.reorder("tickets.created_at DESC").paginate(page: params[:page])
    elsif filter == '2'
      @tickets = Ticket.reorder("tickets.created_at ASC").paginate(page: params[:page])
    end
  end

  def create_ticket
    @employee = current_employee
    @tickets = Ticket.paginate(page: params[:page])
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
  end
  
  def create
    @employee = Employee.new(employee_params)    # Not the final implementation!
    if @employee.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @employee
    else
      render 'new'
    end
  end
  
  def edit
    @employee = Employee.find(params[:id])
  end
  
  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(employee_params)
      flash[:success] = "Profile updated"
      redirect_to @employee
    else
      render 'edit'
    end
  end
  private

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :email, :password,
                                   :password_confirmation)
    end
    
    # Before Filters
    
    # Confirms a logged-in user.
    def logged_in_employee
      unless employee_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to employee_login_url
      end
    end

    # Confirms the correct user.
    def correct_employee
      @employee = Employee.find(params[:id])
      redirect_to(root_url) unless @employee == current_employee
    end
end
