class CustomersController < ApplicationController
  before_action :logged_in_employee, only: [:index,:destroy, :show_info]
  before_action :logged_in_customer, only: [:edit, :update, :show]
  before_action :correct_customer,   only: [:edit, :update, :show]
 
  def new
    @customer = Customer.new
  end
  
  def show
    @customer = Customer.search_by_id(params[:id])
    @tickets = @customer.tickets.order_by_desc.paginate(page: params[:page])
    @ticket = current_customer.tickets.build if customer_logged_in?
    @unreadCount = current_customer.tickets.where(unread: true).count
    @comment = current_customer.tickets.first.comments.build if customer_logged_in? # take this out?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all

    toggleID = params[:ticket_toggle]
    openID = params[:open_ticket]
    tempID = params[:temp_id]
    if(toggleID != nil)
      read = Ticket.find_by(id: toggleID)
      read.update_column(:unread, false)
      openID = tempID
      tempID = toggleID
    end

    if (toggleID == openID)
      tempID = nil
    end
    params[:open_ticket] = openID
    params[:temp_id] = tempID
  end
  
  def show_info
    @customer = Customer.search_by_id(params[:id])
    @tickets = @customer.tickets.order_by_desc.paginate(page: params[:page])
    @employee = current_employee
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all
    @comment = Comment.new

  end
  
  def index
    if params[:search] == ''  #This is useful when user searches for something then deletes the search
      @customers = Customer.all.paginate(page: params[:page])
    elsif params[:search]
      @customers = Customer.search_by_all(params[:search]).paginate(page: params[:page])
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
  
  def edit_info
    @customer = current_customer
  end
  
  def edit_password
    @customer = current_customer
  end
  
  def update
    @customer = current_customer
    
    if !params[:customer][:first_name].nil? && !params[:customer][:last_name].nil? && !params[:customer][:email].nil?
      if @customer.update_attributes(account_info_params)
        flash[:success] = "Profile updated"
        render 'edit_info'
      else
        render 'edit_info'
      end
    elsif !params[:customer][:password].nil? && !params[:customer][:password_confirmation].nil?
      if @customer.authenticate(params[:customer][:old_password])
        if @customer.update_attributes(new_password_params)
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
  
  def destroy
    Customer.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to customers_url
  end
  
  
  private

    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email, :old_password,
                                   :password, :password_confirmation, :send_email, :send_text)
    end
    
    def new_password_params
      params.require(:customer).permit(:password, :password_confirmation)
    end
    
    def account_info_params
      params.require(:customer).permit(:first_name, :last_name, :email, :send_email, :send_text)
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
