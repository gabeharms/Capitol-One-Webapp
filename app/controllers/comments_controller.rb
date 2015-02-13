class CommentsController < ApplicationController
  
  before_action :logged_in_customer, only: [:create, :destroy]
  before_action :correct_customer,   only: :destroy
  
  def create
    if logged_in_customer?
      @comment = current_customer.tickets.find_by(id: params[:comment][:id]).comments.build(comment_params)
      if @comment.save
        flash[:success] = "Comment Posted!"
        redirect_to current_customer    # This changes once the Ticket Conversation page has been created
      else
        flash[:danger]  = "Invalid Comment. Please tell us what your issue is."
        #redirect_to current_customer
        redirect_to root_url    # This changes once the Ticket Conversation page has been created
      end
    else
      #@comment = current_employee.tickets.find_by(id: params[:comment][:id]).comments.build(comment_params)
      @comment = current_employee.new(comment_params)
      if @comment.save
        flash[:success] = "Comment Posted!"
        redirect_to current_customer    # This changes once the Ticket Conversation page has been created
      else
        flash[:danger]  = "Invalid Comment. Please tell us what your issue is."
        #redirect_to current_customer
        redirect_to root_url    # This changes once the Ticket Conversation page has been created
      end
    end
  end
 
  # Need to decide if we want to be able to delete comments or not. Maybe just employees
#  def destroy
#    @comment.destroy
#    flash[:success] = "Ticket deleted"
#    redirect_to request.referrer || root_url
#  end

  private

    def comment_params
      params.require(:comment).permit(:id, :message)
    end
    
    def correct_customer
      @comment = current_customer.tickets.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
