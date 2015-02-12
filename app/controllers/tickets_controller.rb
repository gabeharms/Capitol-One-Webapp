class TicketsController < ApplicationController
  before_action :logged_in_customer, only: [:create, :destroy]
  before_action :correct_customer,   only: :destroy
  
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
    @ticket.destroy
    flash[:success] = "Ticket deleted"
    redirect_to request.referrer || root_url
  end

  private

    def ticket_params
      params.require(:ticket).permit(:title)
    end
    
    def correct_customer
      @ticket = current_customer.tickets.find_by(id: params[:id])
      redirect_to root_url if @ticket.nil?
    end

end
