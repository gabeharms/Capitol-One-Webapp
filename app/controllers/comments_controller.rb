class CommentsController < ApplicationController
  
  before_action :logged_in,  only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    
    if customer_logged_in?
      correct_customer
      
      @comment = current_customer.tickets.find_by(id: params[:comment][:id]).comments.build(comment_params)
      if @comment.save
        
        flash[:success] = "Comment Posted!"
        redirect_to current_customer    # This changes once the Ticket Conversation page has been created
      else
        flash[:danger]  = "Invalid Comment. Please tell us what your issue is."
        #redirect_to current_customer
        redirect_to root_url    # This changes once the Ticket Conversation page has been created
      end
    elsif employee_logged_in?
      correct_employee
      
      @comment = current_employee.tickets.find_by(id: params[:comment][:id]).comments.build(comment_params)
      if @comment.save
        flash[:success] = "Comment Posted!"
        redirect_to current_employee    # This changes once the Ticket Conversation page has been created
      else
        flash[:danger]  = "Invalid Comment. Please tell us what your issue is."
        #redirect_to current_customer
        redirect_to root_url    # This changes once the Ticket Conversation page has been created
      end
    else
      flash[:danger]  = "Please Login."
        #redirect_to current_customer
        redirect_to customer_login_url    # This changes once the Ticket Conversation page has been created
    end
  end
 
  # Further Implemented once the ticket pages can be viewed
  # This will allow us to store the current ticket somewhere which is important
#  def destroy
#    @comment.destroy
#    flash[:success] = "Ticket deleted"
#    redirect_to request.referrer || root_url
#  end

  private

    def comment_params
      params.require(:comment).permit(:id, :message)
    end
    
    def correct_user
      #if customer_logged_in?
        #@comment = current_customer.tickets.find_by(params[:comment][:id]).customer
      
      #@employee = Ticket.find_by(params[:comment][:id]).employee     #implemented once employees have tickets
      redirect_to root_url if @customer != current_customer #|| @employee !=current_employee 
    end                                                        #implemented once employees have tickets
    
    def correct_customer
      @customer = Ticket.find_by(params[:comment][:id]).customer
      redirect_to root_url if @customer.nil? || @customer != current_customer
    end
    
    def correct_employee
      @employee = Ticket.find_by(params[:comment][:id]).employee
      redirect_to root_url if @employee.nil? || @employee != current_employee
    end
    
    # Confirms a logged-in user.
    def logged_in
      unless customer_logged_in? || employee_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to customer_login_url
      end
    end
    
     # Returns true if the user is logged in, false otherwise.
    def employee_logged_in?
      !current_employee.nil?
    end
    
     # Returns true if the user is logged in, false otherwise.
    def customer_logged_in?
      !current_customer.nil?
    end
end
