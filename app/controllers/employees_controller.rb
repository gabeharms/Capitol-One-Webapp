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
    y_Axis3 = [] 
    
    
    intervals = []
    intervals_in_int = []
    units = ""
    max = ""
    if params[:filter] == "1"
      (0..7).to_a.each do |num|
        intervals << num.days.ago
        intervals_in_int << num.days
        units = "days"
        max = "7 days"
      end
    elsif params[:filter] == "2"
      (0..10).to_a.each do |num|
        intervals << (num*3).days.ago
        intervals_in_int << (3*num).days
        units = "days"
        max = "30 days"
      end
    elsif params[:filter] == "3"
     (0..6).to_a.each do |num|
       intervals << num.months.ago
        intervals_in_int << num.months
        units = "months"
        max = "6 months"
     end
    else
     (0..8).to_a.each do |num|
        intervals << (num*3).hours.ago
        intervals_in_int << (3*num).hours
        units = "hours"
        max = "24 hours"
      end
    end
     if ( params[:type] == "interaction_analysis")
      intervals1 = intervals.deep_dup
      intervals_in_int1 = intervals_in_int.deep_dup
      @chart  = build_interaction_graph1(y_Axis, y_Axis1, intervals, intervals_in_int, units, max)
      @chart1 = build_interaction_graph2(y_Axis2, y_Axis3, intervals1, intervals_in_int1, units, max)
    elsif (params[:type] == "rating")
      @chart = build_rating_chart(y_Axis, intervals, intervals_in_int, units, max)
    elsif ( params[:type] == "employee_activity") 
      intervals1 = intervals.deep_dup
      @chart =  build_employee_activity_graph1(y_Axis, intervals, intervals_in_int, units, max)
      @chart1 = build_employee_activity_graph2(y_Axis1, intervals1, intervals_in_int, units, max)
    elsif ( params[:type] == "efficiency")     
      @chart =  build_efficiency_graph1(x_Axis, x_Axis1, y_Axis1, x_Axis2, y_Axis2, intervals, units, max)
      @chart1 = build_efficiency_graph2(x_Axis, y_Axis, intervals, intervals_in_int, units, max) 
    elsif (params[:type] == "website_analytics")
      @chart =  build_website_chart1(x_Axis1, y_Axis1, y_Axis2, intervals)
      @chart1 = build_website_chart2(y_Axis1, y_Axis2, intervals)
      @chart2 = build_website_chart3(y_Axis, intervals, intervals_in_int, units, max)
    else  
      @chart = build_category_graph(intervals, intervals_in_int, x_Axis, y_Axis)
      
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
    
    def build_pie_graph( graph1, graph2, graph_title, has_two_graphs)

      LazyHighCharts::HighChart.new('pie', :style=>"height:100%", :style=>"width:100%") do |f|
        f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
        f.title({ :text=> graph_title })
        f.series( graph1 )
        if has_two_graphs
          f.series( graph2 )
        end
        f.plot_options(:pie=> {:allowPointSelect=>true, :cursor=>"pointer", :dataLabels=> {:enabled=>true,:color=>"black",:style=> {:font=>"13px Trebuchet MS, Verdana, sans-serif"} } })
      end
    end
    
    def build_line_graph( xAxis, yAxis, graph_title, axis_title, color)

      LazyHighCharts::HighChart.new('pie', :style=>"height:100%", :style=>"width:100%") do |f|
        f.title({ :text=> graph_title })
        f.options[:xAxis][:categories] =  xAxis
        f.series(:color=> color, :name=>graph_title, :data=> yAxis )
        f.yAxis [ {:title => {:text => axis_title} }]
      end
    end
    
    # Graphing Functions
    def build_category_graph(intervals, intervals_in_int, x_Axis, y_Axis)
      
      intervals.reverse!
      combinedData = []
      colors = []
      @tickets = Ticket.where("created_at > ?", intervals[0])
      
      @categories.each_with_index do |category, index|
        combinedData[index] = Hash.new
        combinedData[index][:name]  = category.name
        combinedData[index][:y]     = @tickets.where(ticket_category_id: category.id).count
        colors[index].nil? ? "" : combinedData[index][:color] = colors[index]
      end
  
      graph1_params = Hash.new 
        graph1_params[:type] = 'pie'
        graph1_params[:name] ="Tickets per Category"
        graph1_params[:data] = combinedData
        
      build_pie_graph(graph1_params, nil, "Tickets per Category", false )
    end
    
    def build_efficiency_graph1(x_Axis, x_Axis1, y_Axis1, x_Axis2, y_Axis2, intervals, units, max)
        
        intervals.reverse!
        rating_labels = ["1 Star", "2 Stars", "3 Stars", "4 Stars", "5 Stars"]
        colors = ['#B43104', '#DBA901', '#D7DF01', '#86B404', '#4B8A08']
        combinedData = []
        combinedData2 = []
        @ratings = Rate.where("created_at > ?", intervals[0])
        @tickets = Ticket.where("created_at > ?", intervals[0])
        @statuses = TicketStatus.all
        
        (0..4).each do |index|
          combinedData2[index] = Hash.new
          combinedData2[index][:name] = rating_labels[index]
          combinedData2[index][:y]    = @ratings.where(:stars => index+1).count
          colors[index].nil? ? "" : combinedData2[index][:color] = colors[index]
        end 
        
        colors = ['#B43104', '#4B8A08']
        @statuses.each_with_index do |status, index|
          combinedData[index] = Hash.new
          combinedData[index][:name]  = status.status
          combinedData[index][:y]     = @tickets.where(ticket_status_id: status.id).count
          colors[index].nil? ? "" : combinedData[index][:color] = colors[index]
        end
        
        graph1_params = Hash.new 
          graph1_params[:type] = 'pie'
          graph1_params[:name] ="Resolved vs In Progress"
          graph1_params[:data] = combinedData
          graph1_params[:size] = 150
          graph1_params[:center] = [25, 80]
        graph2_params = Hash.new 
          graph2_params[:type] = 'pie'
          graph2_params[:name] ='Employee Ratings'
          graph2_params[:data] = combinedData2
          graph2_params[:size] = 150
          graph2_params[:center] = [400, 80]
          
        build_pie_graph(graph1_params, graph2_params, "Ticket Statuses & Ticket Ratings", true )
     end
     
     def build_efficiency_graph2(x_Axis, y_Axis, intervals, intervals_in_int, units, max)
   
        intervals_in_int.reverse!
        previous_time = Time.now
        
        intervals.reverse!.each_with_index do |time, index|
          total_hours = 0
          total_tickets = 0
          Ticket.where("created_at < ?", time).where.not("claimed_at" => nil).each do |ticket|
             total_hours = total_hours + ((ticket.claimed_at - ticket.created_at) / 3600)
             total_tickets = total_tickets + 1
          end
          (total_tickets == 0) ? y_Axis << 0 : y_Axis << total_hours/total_tickets
          previous_time = time
        end
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        intervals[0] = max

        build_line_graph(intervals, y_Axis, 'Average Time to Claim a Ticket', "Hours", "#A4A4A4")   
      end
      
       def build_employee_activity_graph1(y_Axis, intervals, intervals_in_int, units, max)
     
        previous_time = Time.now
        intervals_in_int.reverse!
        intervals.reverse!.each_with_index do |time, index|
          y_Axis  << Ticket.where.not("employee_id" => nil).where("created_at < ?", time).where("ticket_status_id" => 1).count.to_f  / Employee.all.count.to_f
          previous_time = time
        end
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals[intervals.count-1] = "Now"
        intervals[0] = max
        
        build_line_graph(intervals, y_Axis, 'Claimed Tickets per Employee', "Tickets per Employee", "blue")   
      end
      
      def build_employee_activity_graph2(y_Axis1, intervals2, intervals_in_int2, units, max)
        y_Axis1 = []
        previous_time = Time.now
        intervals_in_int2.reverse!
        intervals2.reverse!.each_with_index do |time, index|
          y_Axis1 << Comment.where("comments.created_at <= ? AND initiator == ?", time, true).includes(:ticket).where("tickets.ticket_status_id" => 1).references(:ticket).count.to_f / Employee.all.count.to_f
          previous_time = time
        end
        intervals2.each_with_index do |time, index|
          intervals2[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int2[index], false, :only => units)
        end
        intervals2.reverse!
        intervals2[intervals2.count-1] = "Now"
        intervals2[0] = max
        
        build_line_graph(intervals2, y_Axis1, 'Average Comments per Employee', "Comments per Employee", "green")   
      end
     
    def build_rating_chart(y_Axis, intervals, intervals_in_int, units, max)
         
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
        intervals[0] = max
        LazyHighCharts::HighChart.new('spline', :style=>"height:100%", :style=>"width:100%") do |f|
          f.title({ :text=>"Average Overall Employee Rating"})
          f.options[:xAxis][:categories] =  intervals
          f.series(:color=> "red", :type=> 'spline',:name=> 'Average', :data=> y_Axis)
          f.yAxis [ {:title => {:text => "Stars ( Out of 5 )"} }]
          f.yAxis(:min=> 0, :max=>5)
          f.yAxis [ {:title => {:text => "Stars"} }]

      end
    end
    
    def build_interaction_graph1(y_Axis, y_Axis1, intervals, intervals_in_int, units, max)
        previous_time = intervals[intervals.count-1] - intervals_in_int[1]
        intervals_in_int.reverse!

        intervals.reverse!.each do |time, index|
          y_Axis  << Ticket.where("created_at <= ? AND created_at > ? AND created_by_customer == ?", time, previous_time, false).count
          y_Axis1 << Ticket.where("created_at <= ? AND created_at > ? AND created_by_customer == ?", time, previous_time, true).count
          previous_time = time
        end
        intervals.each_with_index do |time, index|
          intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        
        intervals[intervals.count-1] = "Now"
        intervals[0] = max
        LazyHighCharts::HighChart.new('column') do |f|
          f.options[:xAxis][:categories] = intervals
          f.series(:name=>'Employees',:data=> y_Axis)
          f.series(:name=>'Customers',:data=> y_Axis1)     
          f.title({ :text=>"Ticket Creation by User"})
          f.options[:chart][:defaultSeriesType] = "column"
          f.yAxis [ {:title => {:text => "Tickets"} }]
          #f.plot_options({:column=>{:stacking=>"percent"}})
        end
      end
      
       def build_interaction_graph2(y_Axis2, y_Axis3, intervals2, intervals_in_int, units, max)
          previous_time = intervals2[intervals2.count-1] - intervals_in_int[1]
          intervals2.reverse!.each do |time, index|
            y_Axis2  << Comment.where("created_at <= ? AND created_at > ? AND initiator == ?", time, previous_time, true).count
            y_Axis3 << Comment.where("created_at <= ? AND created_at > ? AND initiator == ?", time, previous_time, false).count
  
            previous_time = time
        end

        intervals2.each_with_index do |time, index|
          intervals2[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
        end
        intervals2.reverse!
        intervals2[intervals2.count-1] = "Now"
        intervals2[0] = max
        LazyHighCharts::HighChart.new('column') do |f|
          f.options[:xAxis][:categories] = intervals2
          f.series(:name=>'Employees',:data=> y_Axis2)
          f.series(:name=>'Customers',:data=> y_Axis3)     
          f.title({ :text=>"Comment Creation by User"})
          f.options[:chart][:defaultSeriesType] = "column"
          f.yAxis [ {:title => {:text => "Comments"} }]
          #f.plot_options({:column=>{:stacking=>"percent"}})
        end
      end
      
      def build_website_chart1(x_Axis1, y_Axis1, y_Axis2, intervals)
          
          operatingSystem_labels = ["Windows 7", "Windows 8.1", "Linux", "Mac OS X", "Android", "iOS"]
          colors = []
          combinedData = [] 
          combinedData2 = []

          @visits = Visit.where("started_at > ?", intervals[intervals.count-1])
          operatingSystem_labels.each_with_index do |os, index|
            combinedData2[index] = Hash.new
            combinedData2[index][:name]  = os
            combinedData2[index][:y]     =  @visits.where(:os => os).count
            colors[index].nil? ? "" : combinedData2[index][:color] = colors[index]
          end

          y_Axis1 = Hash.new
          @visits = Visit.where("started_at > ?", intervals[intervals.count-1])
          @visits.each do |visit|
              if y_Axis1[visit.region] == nil
                  x_Axis1 << visit.region
                  y_Axis1[visit.region] = 1
              else
                  y_Axis1[visit.region] = y_Axis1[visit.region] + 1
              end
          end
          
          x_Axis1.each_with_index do |xData, index|
            combinedData[index] = Hash.new
            combinedData[index][:name]  = xData
            combinedData[index][:y]     = y_Axis1[xData]
            colors[index].nil? ? "" : combinedData[index][:color] = colors[index]
          end
          
          graph1_params = Hash.new 
            graph1_params[:type] = 'pie'
            graph1_params[:name] ="Traffic Origins"
            graph1_params[:data] = combinedData
            graph1_params[:size] = 125
            graph1_params[:center] = [25, 70]
          graph2_params = Hash.new 
            graph2_params[:type] = 'pie'
            graph2_params[:name] ='Operating Systems'
            graph2_params[:data] = combinedData2
            graph2_params[:size] = 125
            graph2_params[:center] = [400, 70] 
          
          build_pie_graph(graph1_params, graph2_params, "Traffic Origins & Traffic Operating Systems", true )
      end
      
      def build_website_chart2(y_Axis1, y_Axis2, intervals)
          behaviors = ["$click","$view", "$change", "$submit"]
          behaviors_copy = ["click", "view", "value change", "submit"]
          deviceTypes =  ["Desktop", "Tablet", "Mobile"]
          combinedData = []
          combinedData2 = []
          colors = []
          
          @events = Ahoy::Event.where("time > ?", intervals[intervals.count-1])
          @devices = Visit.where("started_at > ?", intervals[intervals.count-1])
          
          behaviors.each_with_index do |behavior, index|
            combinedData2[index] = Hash.new
            combinedData2[index][:name]  = behaviors_copy[index]
            combinedData2[index][:y]     =  @events.where(:name => behavior).count
            colors[index].nil? ? "" : combinedData2[index][:color] = colors[index]
          end
          
          deviceTypes.each_with_index do |type, index|
            combinedData[index] = Hash.new
            combinedData[index][:name]  = type
            combinedData[index][:y]     =  @devices.where(:device_type => type).count
            colors[index].nil? ? "" : combinedData2[index][:color] = colors[index]
          end
          
          graph1_params = Hash.new 
            graph1_params[:type] = 'pie'
            graph1_params[:name] ="Devices"
            graph1_params[:data] = combinedData
            graph1_params[:size] = 125
            graph1_params[:center] = [25, 60]
          graph2_params = Hash.new 
            graph2_params[:type] = 'pie'
            graph2_params[:name] ='Website Activity'
            graph2_params[:data] = combinedData2
            graph2_params[:size] = 125
            graph2_params[:center] = [400, 60] 
          
          build_pie_graph(graph1_params, graph2_params, "Devices & Website Activity", true )
      end
      
      def build_website_chart3(y_Axis, intervals, intervals_in_int, units, max)
          y_Axis = []
          previous_time = intervals[intervals.count-1] - intervals_in_int[1]
          intervals_in_int.reverse!
          
          intervals.reverse!.each_with_index do |time, index|
              y_Axis  << Ahoy::Event.where("time <= ? AND time > ?", time, previous_time).where(:name => "$view").count
              previous_time = time
          end
          intervals.each_with_index do |time, index|
              intervals[index] = view_context.distance_of_time_in_words(Time.now, Time.now + intervals_in_int[index], false, :only => units)
          end
          
          intervals[intervals.count-1] = "Now"
          intervals[0] = max
          
          build_line_graph(intervals, y_Axis, "Number of Website Hits", "Number of Hits", "green")   
      end
      
end
