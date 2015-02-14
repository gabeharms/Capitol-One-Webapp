class TicketsController < ApplicationController
  before_action :logged_in_customer, only: [:create, :destroy]
  before_action :correct_customer,   only: :destroy
  before_action :correct_user, only: :show
  
  def create
    @ticket = current_customer.tickets.build(ticket_params)
    if @ticket.save
      flash[:success] = "Ticket Created! You'll be hereing from us shortly."
      redirect_to current_customer
    else
      flash[:danger]  = "Invalid Post. Please tell us what your issue is."
      #redirect_to current_customer
      redirect_to current_customer
    end
  end

  def destroy
    # Need a better way to delete so employee can still see
    #@ticket.customer_id = nil
    #@ticket.save
    @ticket.destroy
    flash[:success] = "Ticket deleted"
    redirect_to request.referrer || root_url
  end

  def show
    @ticket = Ticket.find(params[:id])
    @comments = Comment.where(ticket_id: @ticket)
    @comment = Comment.new
  end

  private

    def ticket_params
      params.require(:ticket).permit(:title)
    end
    
    def correct_customer
      @ticket = current_customer.tickets.find_by(id: params[:id])
      redirect_to root_url if @ticket.nil?
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

end
