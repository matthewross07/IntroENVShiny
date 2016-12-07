
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
#library(plotly)
#library(ggplot2)
library(DT)
library(reshape2)
library(ggthemes)
library(dplyr)
library(dygraphs)

stream<- read.csv("data/STRFLOW 1962-73.csv")
precipSUM<- read.csv("data/SUMPRECIP 62-73.csv")
ror<- read.csv("data/runoff.csv")
precip<- read.csv("data/PRECIP 1962-73.csv")
streamSUM<- read.csv("data/SUMFLOW 62-73.csv")
#flow<- read.csv("data/STRFLOW 1962-73.csv")
#flow$DATE <- as.Date(flow$DATE, "%Y-%m-%d")
library(shiny)

shinyServer(function(input, output, session) {
  
  
  #Runoff Ratio> About  
  output$ansQ1<- reactive({
    validate( need(input$Q1, "Select an answer") )
    if (input$Q1=="More water leaving the watershed"){answer<- "Correct, see below"}
    else{answer<-"Incorrect"}
    return(answer)
  })
  
  
  #Evapotranspiration>Problem
  output$ansQ3<- reactive({
    validate( need(input$Q3, "Enter your answer above") )
    if(as.numeric(input$Q3)>452 & as.numeric(input$Q3)< 456){answer<- "Correct, see below"}
    else{answer<-"Incorrect"}
    return(answer)
  })
    
  #Evapotranspiration>Solution  
  output$ansQ4<- reactive({
    validate( need( input$Q4, "Select an answer")  )
    if (input$Q4=="inverse"){answer<-"Correct, see below"}
    else{answer<-"Incorrect"}
    return(answer)
  })
  
##Runoff Ratio> Problem  
#runoff ratio for WS_2 in 1962
  output$ansQ2<- reactive({
    validate( need(input$Q2, "Enter your answer above") )
    if(as.numeric(input$Q2)>=0.6 & as.numeric(input$Q2)< 0.64){answer<- "Correct, see below"}
    else{answer<-"Incorrect"}
    return(answer)
  })
#stream data table
  output$streamYA<- DT::renderDataTable(streamSUM, rownames=FALSE,colnames = c('Year', 'WS 2', 'WS 3'),options=list(pageLength=12))
#precip data table
  output$precipYA<- DT::renderDataTable(precipSUM, rownames=FALSE,colnames = c('Year', 'WS 2', 'WS 3'), options=list(pageLength=12))
  

  
  
  ##Runoff Ratio> Solution 
  #reshaping data to display years
  Year<- as.matrix(1962:1973, nrow=11)
  ror<-cbind(Year, ror)
  output$runoffratio<- renderDataTable(datatable(ror, rownames=FALSE,colnames = c('Year', 'WS 2', 'WS 3'), options=list(pageLength=12)))
  
  output$plot<- renderPlot({
    #replace points with click data table
    s = input$runoffratio_rows_selected
    par(mar = c(4, 4, 1, .1))
    plot(x=ror$Year, y=ror$WS_2, type="b", col="blue", ylim=c(0.5,1), xlab= "Year", ylab="Runoff Ratio (out of 1)")
    lines(x=ror$Year, y=ror$WS_3, type="b")
    abline(v=1965, col="green")
    abline(v=1968, col="green")
    if (length(s)) points(ror[s, , drop = FALSE], pch = 19, cex = 2)
    legend('topright', c("WS_2","WS_3", "Years WS_2 is deforested"), lty=1, col=c("blue","black","green"))
  })
  
 
##Evapotranspiration> Problem
#Calculating ET  
  ET<-precipSUM-streamSUM
    ET<- ET[,-1]
    Year<- as.matrix(1962:1973, nrow=12)
    ET<- cbind(Year, ET)
#precip data table
    output$pr<- DT::renderDataTable(
      precipSUM, rownames=FALSE,colnames = c('Year', 'WS 2', 'WS 3'), options=list(pageLength=12)
    )
#stream output data table
    output$st<- DT::renderDataTable(
      streamSUM, rownames=FALSE,colnames = c('Year', 'WS 2', 'WS 3'), options=list(pageLength=12)
    )

##Evapotranspiration> Solution
#ET Table
    output$ET<- DT::renderDataTable(
      ET, rownames=FALSE, colnames = c('Year', 'WS 2', 'WS 3'), options=list(pageLength=12)
    )
    output$etPlot<- renderPlot({
      s = input$ET_rows_selected
      par(mar = c(4, 4, 1, .1))
      plot(ET$Year, ET$WS_2, ylim=c(0,600), type="b", col="blue", main = "Evapotranspiration", xlab="Year", ylab="Evapotranspiration (in mm of water per year)")
      lines(ET$Year, ET$WS_3, type="b")
      abline(v=1965, col="green")
      abline(v=1968, col="green")
      if (length(s)) points(ET[s, , drop = FALSE], pch = 19, cex = 2)
      legend('topright', c("WS_2","WS_3", "Years WS_2 is deforested"), lty=1, col=c("blue","black","green"))
    })
     
   output$rorPlot<- renderPlot({ 
    plot(x=ror$Year, y=ror$WS_2, ylim=c(0.5, 1.0), type="b", col="blue", main="Runoff", xlab="Year", ylab="Runoff Ratio (out of 1)")
    lines(x= ror$Year, y=ror$WS_3, type="b")
    abline(v=1965, col="green")
    abline(v=1968, col="green")
    legend('topright', c("WS_2","WS_3", "Years WS_2 is deforested"), lty=1, col=c("blue","black","green"))
   })
   
   
   
#### PLOTLY CODE
      
#    output$RiverDis <- renderGraph({
#      mstream <- melt(stream, id.vars="DATE", value.name="value", measure.vars= input$wsSelect , variable.name="WS")
#      ggRiverDis<- ggplot(data=mstream, aes(x = DATE, y = value, group=WS, color= WS)) +
#        geom_line() + xlab("Date") + ylab(label= "Rate of River Flow")
#      gg<- gg2list(ggRiverDis)
#      gg$data[[2]]$text<- "Watershed 3"
#      gg$data[[1]]$text<- "Watershed 2"
#      
#      return(list(
#        list(
#          id="RiverDis",
#          task="newPlot",
#          data=gg$data,
#          layout=gg$layout
#        )
#      ))
#    
#    })
#    output$RainVol <- renderGraph({
#      mprecip<- melt(precip, id.vars="DATE", value.name="value", measure.vars = input$wsSelect, variable.name="WS")
#      ggRainVol<- ggplot(data=mprecip, aes(x = DATE, y = value, group=WS, color= WS)) +
#        geom_line() + xlab("Date") + ylab(label= "Precipitation")
#      gg3<- gg2list(ggRainVol)
#      
#      return(list(
#        list(
#          id="RainVol",
#          task="newPlot",
#          data=gg3$data,
#          layout=gg3$layout
#        )
#      ))
#    })
#    
#    
#       
#     output$trendPlot <- renderGraph({
#       mFlow <- melt(stream, id.vars="DATE", value.name="value", measure.vars= input$wsSelect, variable.name="WS")
#       ggFlow<- ggplot(data=mFlow, aes(x = DATE, y = value, group=WS, color= WS)) +
#         geom_line() + xlab("Date") + ylab(label= "Rate of River Flow") 
#       gg<- gg2list(ggFlow)
#       return(list(
#         list(
#           id="trendPlot",
#           task="newPlot",
#           data=gg$data,
#           layout=gg$layout
#         )
#       ))
#       
#     })
  
})

