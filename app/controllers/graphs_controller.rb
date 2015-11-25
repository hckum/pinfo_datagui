class GraphsController < ApplicationController

  def index
    if(params.has_key?(:id) and (params[:id].length > 0))
    	@passedid = params[:id]
      path = File.expand_path("../../../public" + @passedid, __FILE__)
      dataArray = parseCSV(path)
    else
      dataArray = parseData()
    end

    @keysMap=Array.new
    @keysMap=dataArray[0].keys
    if dataArray.length > 5
      @rows = dataArray[0,4]
    else
      @rows = dataArray
    end
  end
  
  def new
  	#This controller will be contain the parser code 
  	# and the logic for displaying different types of tables
    if(params.has_key?(:id) and (params[:id].length > 0))
      id = params[:id]
      path = File.expand_path("../../../public" + id, __FILE__) 
      parsedResult = parseCSV(path)
    else
      parsedResult = parseData()
    end

    xAxisHeadings = params[:xaxis];
    yAxisHeadings = getYAxisHeadings(parsedResult)
    xAxisLabel    = params[:xUnits]
    yAsixLabel    = params[:yUnits]
    typeOfGraph   = params[:graphType]

    #For rows and tableHeadings for displaying table with chart
    @rows = parsedResult
    @tableHeadings = [xAxisHeadings] + yAxisHeadings


    #Getting data for both axis
    xAxisCategories = getXAxisCategories(parsedResult, xAxisHeadings)
    yAxisData = getYAxisData(parsedResult, yAxisHeadings)

    #Creating chart
    if typeOfGraph == 'Bar Graph'
      createBarChart(xAxisCategories, yAxisHeadings, yAxisData, xAxisLabel, yAsixLabel)
    else
      createLineChart(xAxisCategories, yAxisHeadings, yAxisData, xAxisLabel, yAsixLabel)
    end

  end


end
