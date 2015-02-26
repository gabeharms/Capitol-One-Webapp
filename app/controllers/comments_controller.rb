class CommentsController < ApplicationController
  
  before_action :logged_in,  only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    
    @ticket = Ticket.find_by(id: params[:comment][:id])
    @ticket.ticket_status_id = 1
    @comment = Ticket.find_by(id: params[:comment][:id]).comments.build(message: params[:comment][:message], picture: params[:comment][:picture])

    if ( employee_logged_in? )
      @ticket.employee = current_employee
      
      @comment.employee = current_employee
      @comment.initiator = true
     
      if params[:comment][:redirect_location] == 'show_info'
        redirect_location = customer_show_info_path(id: @ticket.customer.id) 
      else
        redirect_location = @ticket
      end
      
    else
      @comment.employee = nil 
      @comment.initiator = false
      redirect_location = current_customer
    end

    if @comment.save && @ticket.save
      flash[:success] = "Comment Posted!"
    else
      flash[:danger]  = "Invalid Comment. Please tell us what your issue is."
    end
      
    redirect_to redirect_location   # This changes once the Ticket Conversation page has been created0
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
