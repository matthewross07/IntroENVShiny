
library(shiny)
library(leaflet)



all<- read.csv("data/all_stations.csv")
subset<- read.csv("data/relevant_stations50.csv")
sl<- read.csv("data/seaLevel50.csv")
i<- read.csv("data/newIce.csv")


shinyServer(function(input, output) {
  
#Isolating lat and lon data for the leaflet
lng<-subset$long
lat<-subset$lat
lng2<- subset$long
lat2<- subset$lat

#Does sea level rise evenly around the globe?
output$ans1<- reactive({
  validate( need(input$q1, "Select an Answer") )
  if(input$q1=="No"){answer<- "Correct. This relationship will be explored later in this module"}
  else{answer<-"Incorrect"}
  return(answer)
})
#Does the loss of ice and snow cover accelerate global warming?
output$ans2<- reactive({
  validate( need(input$q2, "Select an Answer") )
  if(input$q2=="Yes"){answer<- "Correct, it is part of a positive feedback loop"}
  else{answer<-"Incorrect"}
  return(answer)
})

#Does melting of sea ice contribute to sea level rise?
output$ans3<- reactive({
  validate( need(input$q3, "Select an Answer") )
  if(input$q3=="No"){answer<- "Correct. Ice floating in water displaces exactly the same volume of water that it is made up of. As it melts, the water level stays the same."}
    #"Correct. Ice floating in water displaces exactly the same volume of water that it is made up of. As it melts, the water level stays the same."}
  else{answer<-"Incorrect, does a drink with ice overflow as the ice melts?"}
  return(answer)
})

#Does melting of land based ice contribute to sea level rise?
output$ans4<- reactive({
  validate( need(input$q4, "Select an Answer") )
  if(input$q2=="Yes"){answer<- "Correct. Ice melt from land will raise sea level because of the additional volume added"}
  else{answer<-"Incorrect, if you add water to a glass with ice will the level rise?"}
  return(answer)
})
#Juneau, AK
output$a5<- reactive({
  validate( need(input$q5, "Enter the number (format:-0.5)") )
  if(input$q5>=-13 & input$q5<13.2){answer<- "Correct"}
  else{answer<-"Incorrect"}
  return(answer)
})
#Washington, DC
output$a6<- reactive({
  validate( need(input$q6, "Enter the number") )
  if(input$q6>=3 & input$q6<3.3){answer<- "Correct"}
  else{answer<-"Incorrect"}
  return(answer)
})
#Grand Isle, LA
output$a7<- reactive({
  validate( need(input$q7, "Enter the number") )
  if(input$q7>=9 & input$q7<9.2){answer<- "Correct"}
  else{answer<-"Incorrect"}
  return(answer)
})
#San Diego, CA
output$a8<- reactive({
  validate( need(input$q8, "Enter the number") )
  if(input$q8>=2 & input$q8<2.2){answer<- "Correct"}
  else{answer<-"Incorrect"}
  return(answer)
})

#determining colors/ bins for data in leaflet
breakpoints <- c(-18,-12,-6,0,3,6,9,12)
colors<- c('#d53e4f', '#f46d43', '#fdae61', '#fee08b','#abdda4', '#66c2a5', '#3288bd')
qpal <- colorBin(colors[7:1], subset$mm_yr, bins=breakpoints[8:1])
labels<-c("9-12","6-9","3-6","0-3","-6 to 0","-12 to -6", "-18 to -12")

##Leaflet
output$map= renderLeaflet({
  leaflet() %>% addProviderTiles("Esri.NatGeoWorldMap") %>% #addCircleMarkers(lng= lng2, lat=lat2, stroke=F, fillColor='#666666', radius=all$mm_yr, fillOpacity=0.8, popup=paste(all$mm_yr, "mm/yr", all$Name))%>% 
    addCircleMarkers(lng=lng,lat=lat, stroke=F, color= '#666666', fillColor= qpal(subset$mm_yr), weight=4, opacity=1,  fillOpacity=0.8, popup=paste(subset$mm_yr,"mm/yr", subset$Name)) %>% setView(lng=-110,lat=42,zoom=2) %>%
    addLegend(position = "topright", title = "trend (mm/yr)", pal=qpal, values= subset$mm_yr, opacity=0.7, labels=labels)
})

#fetching the yearly trend from a separate dataset than was clicked.
#the map data is sl, the individual station data is subset
trend<- eventReactive(input$map_marker_click,{
  x<- input$map_marker_click
  #validate(need((x$lat in subset$lat),"Please Select one of the yellow circles, the trend for this has not been uploaded yet"))
  if (x$lat %in% subset$lat==FALSE){output$error= renderText({"Please Select one of the yellow circles, the trend for this has not been uploaded yet"})}
  else {output$error= renderText({"Please Select a marker on the map"})
  ww <- which(all$lat==x$lat & all$long==x$lng)
  find <- all[ww, ]
  results<- sl[,which(colnames(sl)==paste("X",find$ID, sep=''))]
  return (results)
  }})

#function that just retreives the name and the trend (for use in the axis titles in the plots)
find_name<- reactive({
  x<-input$map_marker_click
  ww <- which(subset$lat==x$lat & subset$long==x$lng)
  find <- subset[ww, ]
  return (list(find$Name, find$mm_yr))
})
  
z<- merge(sl,i, by.x='year', by.y='Group.1', all=TRUE)  
output$trendPlot<- renderPlot({
  validate(need((input$map_marker_click), "To Begin, select a marker on the map"))
  par(mfrow=c(2,1))
  plot(x=z$year, y=trend(), xlab= "Year", ylab= paste("Sea Level Trend (mm) for :", find_name()[[1]]), pch= 18, col= "darkcyan", main=paste("Overall Trend:", find_name()[2], "mm per year"))
  abline(lm(z$year~trend()))
  #stats()$r2
  #stats()$p
  #   }
  hist(subset$mm_yr, main= "Distribution of US Sea Level Changes", breaks= 50, xlab="change in mm/yr", col = colorQuantile(colors, subset$mm_yr))
  x<- input$map_marker_hover
  x2<- c(x$lat, x$lon)
  #print(find_name()[[2]])
  abline(v=find_name()[[2]], col="#FFCC00", lwd=3)
}, height=500)


qpal <- colorBin(colors[7:1], subset$mm_yr, bins=breakpoints[8:1])
output$hist<- renderPlot({ hist(subset$mm_yr, main= "Distribution of US Sea Level Changes", breaks= 50, xlab="change in mm/yr", col = qpal(subset$mm_yr))
  #x<- input$map_marker_hover
  #x2<- c(x$lat, x$lon)
  #print(find_name()[[2]])
  abline(v=find_name()[[2]], col="#FFCC00", lwd=3)})

})

