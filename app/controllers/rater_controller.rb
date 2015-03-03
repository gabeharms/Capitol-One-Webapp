class RaterController < ApplicationController

  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_user, params[:dimension]
     
      employee_id = Ticket.find_by(id: params[:id]).employee_id
      if (!employee_id.nil?)
        Employee.find_by(id: employee_id).update_rating(params[:score].to_f)
      end
      render :json => true
    else
      render :json => false
    end
  end
end
