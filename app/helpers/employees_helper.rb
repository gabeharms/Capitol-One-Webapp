module EmployeesHelper
  
  
   # Graphing Functions
    def build_category_graph(intervals, intervals_in_int, x_Axis, y_Axis)
      
      intervals.reverse!
      @tickets = Ticket.where("created_at > ?", intervals[0])
      @categories.each do |c|
        x_Axis << c.name
        y_Axis << @tickets.where(ticket_category_id: c.id).count
      end
     
     combinedData = []
     x_Axis.each_with_index do |xData, index|
       combinedData << [xData, y_Axis[index]]
     end
     LazyHighCharts::HighChart.new('pie', :style=>"height:100%", :style=>"width:100%") do |f|
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
