class CommentsController < ApplicationController
  
  before_action :logged_in,  only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    
    @ticket = Ticket.find_by(id: params[:comment][:id])
    @ticket.ticket_status_id = 1
    @ticket.updated_at = Time.now
    
    @comment = Ticket.find_by(id: params[:comment][:id]).comments.build(message: params[:comment][:message], picture: params[:comment][:picture])

    if ( employee_logged_in? )
      @ticket.unread = true
      
      if @ticket.employee != current_employee
        @ticket.employee = current_employee
        @ticket.claimed_at = Time.now
      end
      
      @comment.employee = current_employee
      @comment.initiator = true
     
    else
      @comment.employee = nil 
      @comment.initiator = false
    end

    if @comment.save && @ticket.save
      flash[:success] = "Comment Posted!"
    else
      flash[:danger]  = "Invalid Comment. Please tell us what your issue is."
    end
    
    if( employee_logged_in? )
      redirect_to @ticket
    else  #might be able to take out :ticket_id here since we are not reopening the comments on page load
      redirect_to :controller => 'customers', :action => 'show', :id => @ticket.customer.id, :ticket_id => @ticket.id   # This changes once the Ticket Conversation page has been created0
    end
  end
 
  # Further Implemented once the ticket pages can be viewed
  # This will allow us to store the current ticket somewhere which is important
  def destroy
    @comment = Comment.find_by(id: params[:comment_id])
    @ticket = @comment.ticket
    @comment.destroy
    flash[:success] = "Comment deleted"

    if ( employee_logged_in? )
      redirect_to @ticket
    else
      redirect_to current_customer
    end
    
  end

  private

    def comment_params
      params.require(:comment).permit(:id, :message, :comment_id, :picture)
    end
    
                                                        #implemented once employees have tickets
    
    def correct_customer
      @customer = Ticket.find_by(id: params[:comment][:id]).customer
      redirect_to root_url if @customer.nil? || @customer != current_customer
    end
    
    def correct_employee
      @employee = Ticket.find_by(id: params[:comment][:id]).employee
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

    def find_customer
      @ticket = current_customer.tickets.find_by(id: params[:id])
      if @ticket.nil?
        false
      else
        true
      end
    end

    def correct_user
      if(!employee_logged_in?)
        if(!current_customer.nil?)
          if(!find_customer)
            store_location
            flash[:danger] = "Please log in."
            redirect_to customer_login_url
          end
        else
          store_location
          flash[:danger] = "Please log in."
          redirect_to customer_login_url
        end 
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
