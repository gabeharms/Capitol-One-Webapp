class EmployeesController < ApplicationController
  before_action :logged_in_employee, only: [:edit, :update, :display_tickets, :show]
  before_action :correct_employee,   only: [:edit, :update, :show]
  
  
  def new
    @employee = Employee.new
  end

  def show
    
    @employee = Employee.find(params[:id])
    @tickets = current_employee.tickets.paginate(page: params[:page])
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all
    @customer = Customer.search_by_id(params[:customer_id])
    order = params[:order_select]

    if order == 'Most_Recent' || order.nil?
      @tickets = current_employee.tickets.ticket_order_most_recent(params[:filter], params[:status], params[:category]).order_by_desc.paginate(page: params[:page])
    elsif order == 'Least_Recent'
      @tickets = current_employee.tickets.ticket_order_least_recent(params[:filter], params[:status], params[:category]).order_by_asc.paginate(page: params[:page])
    end
  
     respond_to do |format|
      format.html { }
      format.js 
    end

  end
  
  def display_tickets
    
    @employee = current_employee
    @tickets = Ticket.paginate(page: params[:page])
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all
    @customer = Customer.search_by_id(params[:customer_id])
   
    order = params[:order_select]
    if order == 'Most_Recent' || order.nil?
      @tickets = Ticket.ticket_order_most_recent(params[:filter], params[:status], params[:category]).order_by_desc.paginate(page: params[:page])
    elsif order == 'Least_Recent'
      @tickets = Ticket.ticket_order_least_recent(params[:filter], params[:status], params[:category]).order_by_asc.paginate(page: params[:page])
    end
    
     respond_to do |format|
      format.html { }
      format.js 
    end
  end

  def display_statistics
    @categories = TicketCatagory.all
    @tickets = Ticket.filter_by_time(params[:filter])
    @employee = current_employee
    @employees = Employee.all
  end

  def create
    @employee = Employee.new(employee_params)    # Not the final implementation!
    if @employee.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to employee_tickets_path
    else
      render 'employees/new'
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
