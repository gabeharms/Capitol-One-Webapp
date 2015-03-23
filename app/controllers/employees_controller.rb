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
  
  def edit_info
    @employee = current_employee
  end
  
  def edit_password
    @employee = current_employee
  end
  
  def update
    @employee = current_employee
    
    if !params[:employee][:first_name].nil? && !params[:employee][:last_name].nil? && !params[:employee][:email].nil?
      if @employee.update_attributes(account_info_params)
        flash[:success] = "Profile updated"
        render 'edit_info'
      else
        render 'edit_info'
      end
    elsif !params[:employee][:password].nil? && !params[:employee][:password_confirmation].nil?
      if @employee.authenticate(params[:employee][:old_password])
        if @employee.update_attributes(new_password_params)
          flash[:success] = "Profile updated"
          render 'edit_password'
        else
          render 'edit_password'
        end
      else
          flash.now[:danger]= "The current password you have entered is invalid"
          render 'edit_password'
      end
    else    
          render 'edit_info'
    end
  end
  private

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :email, :old_password,
                                   :password, :password_confirmation)
    end
    
    def new_password_params
      params.require(:employee).permit(:password, :password_confirmation)
    end
    
    def account_info_params
      params.require(:employee).permit(:first_name, :last_name, :email)
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
