class StaticPagesController < ApplicationController
  def home
    @ticket = current_customer.tickets.build if customer_logged_in?

    #@feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
