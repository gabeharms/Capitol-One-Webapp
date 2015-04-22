class TicketsController < ApplicationController
  before_action :logged_in_user, only: :create
  #before_action :correct_customer,   only: :destroy
  before_action :correct_user, only: [:show, :destroy]
  
  
  
  protect_from_forgery :except => :api_create 
  
  def create
    if(customer_logged_in?)
      @ticket = current_customer.tickets.build(ticket_params)
      
      @ticket.note = nil
      @ticket.ticket_status_id = 1
      @ticket.ticket_category_id = nil
      @ticket.created_by_customer = true
      @ticket.visible = true
      
      if @ticket.save
        flash[:success] = "Ticket Created! You'll be hearing from us shortly."
        redirect_to current_customer
      else
        flash[:danger]  = "Invalid Post. Please tell us what your issue is."
        #redirect_to current_customer
        redirect_to current_customer
      end
    elsif(employee_logged_in?)
      @ticket = Ticket.new(ticket_params)
     
      @ticket.note = nil
      @ticket.employee = current_employee
      @ticket.claimed_at = Time.now
      @ticket.ticket_status_id = 1
      @ticket.created_by_customer = false
      @ticket.visible = true
      @ticket.unread = true
      
      if @ticket.save
        flash[:success] = "Ticket Created!"
        redirect_to current_employee
      else
        flash[:danger]  = "Invalid Post."
        #redirect_to current_customer
        redirect_to current_employee
      end
    else
       redirect_to customer_login_url
    end
  end

  def api_create
    @ticket = Ticket.new(api_params)
    
    @ticket.created_by_customer = false
    @ticket.visible = true
    @ticket.unread = true

    status = "failed"
    if @ticket.save
      status = "success"
    end
    redirect_to root_url
  end
  
  def api_response
    debugger
  end

  def destroy
    # Need a better way to delete so employee can still see
    #@ticket.customer_id = nil
    #@ticket.save
    Ticket.find(params[:id]).destroy
    flash[:success] = "Ticket deleted"
    redirect_to request.referrer || root_url
  end

  def show
    @ticket = Ticket.find(params[:id])
    @comments = Comment.where(ticket_id: @ticket)
    @comment = Comment.new
    @employee = Employee.find_by(id: @ticket.employee_id)
    @customer = Customer.find_by(id: @ticket.customer_id)
    @category = TicketCatagory.find_by(id: @ticket.ticket_category_id)
    @categories = TicketCatagory.all
    
    if params[:category_select] != nil
      @ticket.update_column(:ticket_category_id, params[:category_select])
    end
    
  end

  def update
    @ticket = Ticket.find(params[:id])
    if(params[:ticket][:note_update] != nil)
      @ticket.note = params[:ticket][:note]
      @ticket.save
      flash[:success] = "Note updated!"
    end

    redirect_to @ticket
  end
  
  def update_status
    ticket = params[:ticket_id]
    if !ticket.nil?
      ticket = Ticket.find(ticket)
      if ticket.ticket_status_id == 1
        ticket.ticket_status_id = 2
      elsif ticket.ticket_status_id == 2
        ticket.ticket_status_id = 1
      end
      
      ticket.save
    end
    redirect_to request.referrer
  end

  def update_employee_on_ticket
    ticket = params[:ticket_id]
    if !ticket.nil?
      ticket = Ticket.find(ticket)
      if ticket.employee.nil?
        ticket.employee = current_employee
        ticket.claimed_at = Time.now
        ticket.save
        redirect_to :controller => 'tickets', :action =>'show', :id => ticket.id
      else
        flash[:danger]  = "Sorry, this ticket has already been claimed."
        redirect_to request.referrer
      end
    end
  end

  private
  
    def api_params
      params.require(:ticket).permit(:customer_id, :title, :ticket_category_id, :ticket_status_id)
    end

    def ticket_params
      params.require(:ticket).permit(:customer_id, :title, :ticket_category_id)
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

    def logged_in_user
      (customer_logged_in? || employee_logged_in?)
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
