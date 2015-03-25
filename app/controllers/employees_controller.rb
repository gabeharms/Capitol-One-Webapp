class EmployeesController < ApplicationController
  before_action :logged_in_employee, only: [:edit, :update, :display_tickets, :show]
  before_action :correct_employee,   only: [:edit, :update, :show]
  
  
  def new
    @employee = Employee.new
  end

  def show
    
    @employee = Employee.find(params[:id])
    @tickets = current_employee.tickets.paginate(page: params[:page])
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all
    @customer = Customer.search_by_id(params[:customer_id])
    order = params[:order_select]

    if order == 'Most_Recent' || order.nil?
      @tickets = current_employee.tickets.ticket_order_most_recent(params[:filter], params[:status], params[:category]).order_by_desc.paginate(page: params[:page])
    elsif order == 'Least_Recent'
      @tickets = current_employee.tickets.ticket_order_least_recent(params[:filter], params[:status], params[:category]).order_by_asc.paginate(page: params[:page])
    end
  
     respond_to do |format|
      format.html { }
      format.js 
    end

  end
  
  def display_tickets
    
    @employee = current_employee
    @tickets = Ticket.paginate(page: params[:page])
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
    @statuses = TicketStatus.all
    @customer = Customer.search_by_id(params[:customer_id])
   
    order = params[:order_select]
    if order == 'Most_Recent' || order.nil?
      @tickets = Ticket.ticket_order_most_recent(params[:filter], params[:status], params[:category]).order_by_desc.paginate(page: params[:page])
    elsif order == 'Least_Recent'
      @tickets = Ticket.ticket_order_least_recent(params[:filter], params[:status], params[:category]).order_by_asc.paginate(page: params[:page])
    end
    
     respond_to do |format|
      format.html { }
      format.js 
    end
  end

  def display_statistics
    @categories = TicketCatagory.all
    @tickets = Ticket.filter_by_time(params[:filter])
    @employee = current_employee
    @employees = Employee.all
    @statuses = TicketStatus.all


    x_Axis = []
    x_Axis1 = []
    x_Axis2 = []
    y_Axis = []
    y_Axis1 = []
    y_Axis2 = []
    
    intervals = []
    intervals_in_int = []
    units = ""

    if params[:filter] == "1"
      (0..7).to_a.each do |num|
        intervals << num.days.ago
        intervals_in_int << num.days
        units = "days"
      end
    elsif params[:filter] == "2"
      (0..10).to_a.each do |num|
        intervals << (num*3).days.ago
        intervals_in_int << (3*num).days
        units = "days"
      end
    elsif params[:filter] == "3"
     (0..6).to_a.each do |num|
       intervals << num.months.ago
        intervals_in_int << num.months
        units = "months"
     end
    else
     (0..8).to_a.each do |num|
        intervals << (num*3).hours.ago
        intervals_in_int << (3*num).hours
        units = "hours"
      end
    end
     if ( params[:type] == "ticket_generation")
        previous_time = Time.now
        intervals_in_int.reverse!
        intervals.reverse!.each do |time|
          y_Axis  << Ticket.where("created_at <= ? AND created_at > ? AND created_by_customer == ?", time, previous_time, false).count
          y_Axis1 << Ticket.where("created_at <= ? AND created_at > ? AND created_by_customer == ?", time, previous_time, true).count
          previous_time = time
        end
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        @chart = LazyHighCharts::HighChart.new('column') do |f|
          f.options[:xAxis][:categories] = intervals
          f.series(:name=>'Employees',:data=> y_Axis)
          f.series(:name=>'Customers',:data=> y_Axis1)     
          f.title({ :text=>"Ticket Creation by User"})
          f.options[:chart][:defaultSeriesType] = "column"
          #f.plot_options({:column=>{:stacking=>"percent"}})
        end
    elsif (params[:type] == "rating")
        previous_time = Time.now
        intervals_in_int.reverse!
        intervals.reverse!.each_with_index do |time, index|
          y_Axis  << Rate.where("created_at <= ?", time).sum(:stars)/ Rate.where("created_at <= ?", time).count
          y_Axis[index] = ( y_Axis[index].nan? ) ? 0 : y_Axis[index]
          previous_time = time
          
        end
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        @chart = LazyHighCharts::HighChart.new('pie', :style=>"height:100%", :style=>"width:100%") do |f|
          f.title({ :text=>"Average Overall Employee Rating"})
          f.options[:xAxis][:categories] =  intervals
          f.series(:type=> 'spline',:name=> 'Average', :data=> y_Axis)
          f.yAxis [ {:title => {:text => "Stars ( Out of 5 )"} }]
      end
    
    elsif ( params[:type] == "comment_postings")
        previous_time = Time.now
        intervals_in_int.reverse!
        intervals.reverse!.each do |time|
          y_Axis  << Comment.where("created_at <= ? AND created_at > ? AND initiator == ?", time, previous_time, true).count
          y_Axis1 << Comment.where("created_at <= ? AND created_at > ? AND initiator == ?", time, previous_time, false).count
          previous_time = time
        end

        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        @chart = LazyHighCharts::HighChart.new('column') do |f|
          f.options[:xAxis][:categories] = intervals
          f.series(:name=>'Employees',:data=> y_Axis)
          f.series(:name=>'Customers',:data=> y_Axis1)     
          f.title({ :text=>"Ticket Creation by User"})
          f.options[:chart][:defaultSeriesType] = "column"
          f.yAxis [ {:title => {:text => "Tickets"} }]
          #f.plot_options({:column=>{:stacking=>"percent"}})
        end
    
    elsif ( params[:type] == "employee_activity") 
        previous_time = Time.now
        intervals_in_int.reverse!
        intervals.reverse!.each_with_index do |time, index|
          y_Axis  << (Ticket.where.not("employee_id" => nil).where("claimed_at > ?", time).where("created_at < ?", time).count.to_f + Ticket.where("claimed_at" => nil).where("created_at < ?", time).count ) / Employee.all.count.to_f
          y_Axis1 << (Comment.where("comments.created_at <= ? AND initiator == ?", time, true).includes(:ticket).where("tickets.claimed_at" => nil).references(:ticket).count.to_f + Comment.where("comments.created_at <= ? AND initiator == ?", time, true).includes(:ticket).where("tickets.claimed_at > ?", time).references(:ticket).count.to_f) / Employee.all.count.to_f
          previous_time = time
        end
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        @chart = LazyHighCharts::HighChart.new('graph', :style=>"width:100% height:50%") do |f|
          f.title({ :text=>"Claimed Tickets per Employee"})
          f.options[:xAxis][:categories] =  intervals
          f.series(:name=> 'Average Tickets per Employee', :data=> y_Axis)
          f.yAxis [ {:title => {:text => "Tickets per Employee"} }]
        end
        @chart1 = LazyHighCharts::HighChart.new('graph', :style=>"width:100% height:50%") do |f|
          f.title({ :text=>"Comments per Employee"})
          f.options[:xAxis][:categories] =  intervals
          f.series(:name=> 'Average Comments per Employee', :data=> y_Axis1)
          f.yAxis [ {:title => {:text => "Comments per Employee"} }]
        end
        
    elsif ( params[:type] == "efficiency")     
        previous_time = Time.now
        intervals_in_int.reverse!
        total_hours = 0
        total_tickets = 0
        
        y_Axis2 = [0,0,0,0,0]
        rating_labels = ["1 Star", "2 Stars", "3 Stars", "4 Stars", "5 Stars"]
        
        
        intervals.reverse!.each_with_index do |time, index|
          Ticket.where("created_at < ?", time).where.not("claimed_at" => nil).each do |ticket|
             total_hours += (ticket.claimed_at - ticket.created_at) / 3600
             total_tickets = total_tickets + 1
          end
          
          if total_tickets == 0
            y_Axis << 0
          else
            y_Axis  << total_hours/total_tickets 
          end
          
      
          previous_time = time
        end
        
        Rate.where("created_at > ?", intervals[0]).each do |rating|
          if rating.stars == 1
            y_Axis2[0] = y_Axis2[0] + 1
          elsif rating.stars == 2
            y_Axis2[1] = y_Axis2[1] + 1
          elsif rating.stars == 3
            y_Axis2[2] = y_Axis2[2] + 1
          elsif rating.stars == 4
            y_Axis2[3] = y_Axis2[3] + 1
          elsif rating.stars == 5
            y_Axis2[4] = y_Axis2[4] + 1
          end 
        end
            
             filter_by = "0"
        @tickets = Ticket.where("created_at > ?", intervals[0])
       @statuses.each do |c|
        x_Axis1 << c.status
        y_Axis1 << @tickets.where(ticket_status_id: c.id).count
      end
       
        
        
        
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        @chart1 = LazyHighCharts::HighChart.new('graph', :style=>"width:100% height:50%") do |f|
          f.title({ :text=>"Average Time to Claim a Ticket"})
          f.options[:xAxis][:categories] =  intervals
          f.series(:name=> 'Average Tickets per Employee', :data=> y_Axis)
          f.yAxis [ {:title => {:text => "Hours"} }]
        end
       
       combinedData = []
     x_Axis1.each_with_index do |xData, index|
       combinedData << [xData, y_Axis1[index]]
      end
      combinedData2 = []
      rating_labels.each_with_index do |xData, index|
       combinedData2 << [xData, y_Axis2[index]]
      end
     @chart = LazyHighCharts::HighChart.new('pie', :style=>"height:100%", :style=>"width:100%") do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
      f.title({ :text=>"Resolved vs In Progress Tickest"})
      f.options[:xAxis][:categories] =  x_Axis1
      series = {
                   :type=> 'pie',
                   :name=> 'Browser share',
                   :data=> combinedData,
                   :center=> [25,80],
                   :size => 150
          }
      f.series(series)
      f.series(:type=> 'pie',:name=> 'Total consumption', 
        :data=> combinedData2,
        :center=> [400, 80], :size => 150, :showInLegend=> false)
      f.plot_options(:pie=>{
            :allowPointSelect=>true, 
            :cursor=>"pointer" , 
            :dataLabels=>{
              :enabled=>true,
              :data => x_Axis,
              :color=>"black",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
      end
    else  
      filter_by = "0"
      @tickets = Ticket.filter_by_time(filter_by)
      @categories.each do |c|
        x_Axis << c.name
        y_Axis << @tickets.where(ticket_category_id: c.id).count
      end
     
     combinedData = []
     x_Axis.each_with_index do |xData, index|
       combinedData << [xData, y_Axis[index]]
     end
     @chart = LazyHighCharts::HighChart.new('pie', :style=>"height:100%", :style=>"width:100%") do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
      f.title({ :text=>"Tickets Per Category"})
      f.options[:xAxis][:categories] =  x_Axis
      series = {
                   :type=> 'pie',
                   :name=> 'Browser share',
                   :data=> combinedData
          }
      f.series(series)
      f.plot_options(:pie=>{
            :allowPointSelect=>true, 
            :cursor=>"pointer" , 
            :dataLabels=>{
              :enabled=>true,
              :data => x_Axis,
              :color=>"black",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
      end
    end
   
    
  end

  def create
    @employee = Employee.new(employee_params)    # Not the final implementation!
    if @employee.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to employee_tickets_path
    else
      render 'employees/new'
    end
  end
  
  def edit_info
    @employee = current_employee
  end
  
  def edit_password
    @employee = current_employee
  end
  
  def update
    @employee = current_employee
    
    if !params[:employee][:first_name].nil? && !params[:employee][:last_name].nil? && !params[:employee][:email].nil?
      if @employee.update_attributes(account_info_params)
        flash[:success] = "Profile updated"
        render 'edit_info'
      else
        render 'edit_info'
      end
    elsif !params[:employee][:password].nil? && !params[:employee][:password_confirmation].nil?
      if @employee.authenticate(params[:employee][:old_password])
        if @employee.update_attributes(new_password_params)
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
  private

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :email, :old_password,
                                   :password, :password_confirmation)
    end
    
    def new_password_params
      params.require(:employee).permit(:password, :password_confirmation)
    end
    
    def account_info_params
      params.require(:employee).permit(:first_name, :last_name, :email)
    end
    
    # Before Filters
    
    # Confirms a logged-in user.
    def logged_in_employee
      unless employee_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to employee_login_url
      end
    end

    # Confirms the correct user.
    def correct_employee
      @employee = Employee.find(params[:id])
      redirect_to(root_url) unless @employee == current_employee
    end
end
