class GraphsController < ApplicationController

  def index

  	@passedid = params[:id]  
    map = Hash.new
    map['Car']= [
 {"year" => 1997, :make => 'Ford', :model => 'E350', :description => 'ac, abs, moon', :price => 3000.00},
 {:year => 1999, :make => 'Chevy', :model => 'Venture "Extended Edition"', :description => nil, :price => 4900.00},
 {:year => 1999, :make => 'Chevy', :model => 'Venture "Extended Edition, Very Large"', :description => nil, :price => 5000.00},
 {"year" => 1996, :make => 'Jeep', :model => 'Grand Cherokee', :description => "MUST SELL!\nair, moon roof, loaded", :price => 4799.00}
] 
    
    map['Truck']= [
 {"year" => 1997, :make => 'Ford', :model => 'E350', :description => 'ac, abs, moon', :price => 3000.00},
 {:year => 1999, :make => 'Chevy', :model => 'Venture "Extended Edition"', :description => nil, :price => 4900.00},
 {:year => 1999, :make => 'Chevy', :model => 'Venture "Extended Edition, Very Large"', :description => nil, :price => 5000.00},
 {"year" => 1996, :make => 'Jeep', :model => 'Grand Cherokee', :description => "MUST SELL!\nair, moon roof, loaded", :price => 4799.00}
] 

  @keysMap=Hash.new
  map.each do |key, array|  	
  	@keysMap[key]=map[key][0].keys
  end
  
  end

  def new
  	#This controller will be contain the parser code 
  	# and the logic for displaying different types of tables
    
    #logic of getting X Y axis rows and columns 
    map = Hash.new
    map['Car']= [
    {"year" => 1997, :make => 'Ford', :model => 'E350', :description => 'ac, abs, moon', :price => 3000.00},
    {:year => 1999, :make => 'Chevy', :model => 'Venture "Extended Edition"', :description => nil, :price => 4900.00},
    {:year => 1999, :make => 'Chevy', :model => 'Venture "Extended Edition, Very Large"', :description => nil, :price => 5000.00},
    {"year" => 1996, :make => 'Jeep', :model => 'Grand Cherokee', :description => "MUST SELL!\nair, moon roof, loaded", :price => 4799.00}
    ] 
    
    graphName = params[:graph];
    yAxis = Array.new
    xaxisName = "initialized" 
    varname = "initialized"
    
    if map.has_key?(graphName) then
      fieldsList = map[graphName][0].keys      
      fieldsList.each do |field|       
        varname = "y_"+"#{field}" +"_"+graphName
        
        flash[:notice]=params[varname]
        if params[varname] == "1" then          
          yAxis.push(field)
        end

        varname = "x_" + "#{field}"  + "_" + graphName
        if params[varname] == "1" then
          xaxisName = field          
        end       
      end
    end   
    
    #logic of getting X Y axis ends here
    # X axis is in xaxisName
    # Y axis is in yAxis array
    # graph name is in graphName
    
  	id = params[:id]
  	path = File.expand_path("../../../public" + id, __FILE__)  	
  	data = Hash.new
  	i = 1
  	average=[0,0,0,0,0,0,0]
  	File.open(path, "r") do |f|
  		f.each_line do |line|
  			line = line.strip()
  			data[i] = line.split(',').map{|s| s.to_i}
  			for k in 0..6
  				average[k]= average[k]+ data[i][k]
  			end
  			
    		
    		i += 1
  		end
	end
 	
 	for i in 0..6
 		average[i]=average[i]/6.0
 	end

	

	@chart = LazyHighCharts::HighChart.new('graph') do |f|
	  f.title({ :text=>"Diabetes Results"})
 	  f.options[:xAxis][:categories] = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday','Sunday']
 	  f.options[:yAxis][:title][:text] = '(in mg/dl)'
	  #f.labels(:items=>[:html=>"Diabetes Value", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ]) 
	  f.series(:type=> 'column',:name=> 'Before Breakfast',:data=> data[1])
	  f.series(:type=> 'column',:name=> 'After Breakfast',:data=> data[2])
	  f.series(:type=> 'column',:name=> 'Before Lunch',:data=> data[3])
	  f.series(:type=> 'column',:name=> 'After Lunch',:data=> data[4])
	  f.series(:type=> 'column',:name=> 'Before Dinner', :data=> data[5])
	  f.series(:type=> 'column',:name=> 'After Dinner', :data=> data[6])
	  f.series(:type=> 'line',:name=> 'Average', :data=> average)

	 
	end 


	@line_chart = LazyHighCharts::HighChart.new('graph') do |f|
	  f.title({ :text=>"Diabetes Results"})
 	  f.options[:xAxis][:categories] = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday','Sunday']
 	  f.options[:yAxis][:title][:text] = '(in mg/dl)'
	  #f.labels(:items=>[:html=>"Diabetes Value", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ]) 
	  f.series(:type=> 'line',:name=> 'Before Breakfast',:data=> data[1])
	  f.series(:type=> 'line',:name=> 'After Breakfast',:data=> data[2])
	  f.series(:type=> 'line',:name=> 'Before Lunch',:data=> data[3])
	  f.series(:type=> 'line',:name=> 'After Lunch',:data=> data[4])
	  f.series(:type=> 'line',:name=> 'Before Dinner', :data=> data[5])
	  f.series(:type=> 'line',:name=> 'After Dinner', :data=> data[6])
	  
  end
end
def show
end

private
def parseCSV
	path = "data.csv";
	data = CSV.read(path);
	flagMultiple = FALSE
	if data[0].length != data[1].length and data[0].length == 1
		flagMultiple = TRUE
	end
	header = []
	result = []
	charts = {}

	if flagMultiple
		k = 1
	else
		k = 0
	end

	while TRUE
		for i in k..data.length - 1
			if data[i].length == 0 or i == data.length
				if flagMultiple
					charts[data[k-1][0]] = result
				else
					charts["Sinlge"] = result
				end
				result = []
				header = []
				k = i+2
				break
			end
			temp = {}
			for j in 0..data[i].length - 1
				if i == k
					header.push(data[i][j])
				else
					temp[header[j]] = data[i][j]
				end
			end
			if i != k
				result.push(temp)
			end
		end

		if k >= data.length
			break
		end

		if  i >= data.length-1
			if flagMultiple
				charts[data[k-1][0]] = result
			else
				charts["Sinlge"] = result
			end
			break
		end
	end
	return charts
end
end
