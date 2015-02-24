class CustomersController < ApplicationController
  before_action :logged_in_employee, only: [:index,:destroy, :show_info]
  before_action :logged_in_customer, only: [:edit, :update, :show]
  before_action :correct_customer,   only: [:edit, :update, :show]
 
  def new
    @customer = Customer.new
  end
  
  def show
    @customer = Customer.search_by_id(params[:id])
    @tickets = @customer.tickets.paginate(page: params[:page])
    @ticket = current_customer.tickets.build if customer_logged_in?
    @comment = current_customer.tickets.first.comments.build if customer_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all

    @all_tickets ||= []
    @statuses.each do |status|
      @all_tickets.push( current_customer.tickets.search_by_status(status.id).order_by_desc)
    end
    
  end
  
  def show_info
    @customer = Customer.search_by_id(params[:id])
    @tickets = @customer.tickets.paginate(page: params[:page])
    @employee = current_employee
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all

    
    @all_tickets ||= []
    @statuses.each do |status|
      @all_tickets.push( @tickets.search_by_status(status.id).order_by_desc)
    end
  end
  
  # Add selection area for search type (last name, ID, etc) and pass this selection
  # over as a hidden param ... then check that value here and call corresponding functions
  def index
    if params[:search] == ''  #checks if search field contains anything. This is usefull, when user searches for something then deletes the search
      @customers = Customer.all.paginate(page: params[:page])
    elsif params[:search]
      @customers = Customer.search_by_first_name(params[:search]).paginate(page: params[:page])
    else
      @customers = Customer.all.paginate(page: params[:page])
    end
  end
  
  def create
    @customer = Customer.new(customer_params)       # Not the final implementation!
    if @customer.save
      customer_log_in @customer
      flash[:success] = "You have successfully created an account!"
      redirect_to @customer
    else
      render 'new'
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Profile updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end
  
  def destroy
    Customer.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to customers_url
  end
  
  
  private

    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email, :password,
                                   :password_confirmation)
    end
  
    # Confirms a logged-in user.
    def logged_in_customer
      unless customer_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to customer_login_url
      end
    end

    # Confirms a logged-in user.
    def logged_in_employee
      unless employee_logged_in?
        flash[:danger] = "You do not have Access"
        redirect_to employee_login_url
      end
    end

    # Returns true if the user is logged in, false otherwise.
    def employee_logged_in?
      !current_employee.nil?
    end
    
    # Confirms the correct user.
    def correct_customer
      @customer = Customer.find(params[:id])
      redirect_to(root_url) unless @customer == current_customer
    end
end
