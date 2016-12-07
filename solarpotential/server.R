library(shiny)
library(rgdal)
library(leaflet)
library(raster)

# pop<- read.csv("popCensus.csv", header=T, sep= ",")
# PV <- readOGR(dsn="new", layer ="Big" , encoding = NULL, use_iconv= NULL)
# m1 <- readOGR(dsn = "Renewable.Data" ,layer = "CountiesSolar", encoding = NULL, use_iconv = NULL)
# 
# ?save
# save(PV,file="solarprojects.RData")
# save(m1, file="solarpotential.RData")
# save(pop, file="popCensus.RData")

load("popCensus.RData")
load("solarpotential.RData")
load("solarprojects.RData") 

cdf<-ecdf(m1$MEAN)

eff<- m1$SUM/pop$POPESTIMATE2014

shinyServer(function(input, output) {
   
  
# leaflet map code for county solar potential 
  test<-  leaflet() %>% addTiles() %>% 
    addPolygons(data= m1, stroke=T, weight=2, fillOpacity= 0.65, 
                smoothFactor= 1.1, color=~colorQuantile("Greens", (eff), n=20)(eff), 
                #layerId=~COUNTYNS, 
                popup= paste(m1$NAME, "has an efficiency of", eff),
                group="Potential per person") %>%
    addLegend(position="topright", title="Potential per person", pal=colorQuantile("Greens", (eff), n=4), values= eff, opacity=0.7) %>%
    addPolygons(data=m1, stroke = T, weight=1, fillOpacity = 0.6, smoothFactor = 1.1,
                  color = ~colorQuantile("YlOrRd", m1$MEAN, n=50)(MEAN),
                  layerId = ~COUNTYNS,
                  popup = paste(m1$NAME, m1$MEAN, "DNI"), group="Solar Potential") %>% 
    addLegend(position = "topright", title = "Solar potential", pal= colorQuantile("YlOrRd", m1$MEAN, n=4), values= m1$MEAN, opacity=0.7, labels=c("a","b")) %>%
      addCircleMarkers(data=PV,lat = PV$latitude,lng = PV$longitude, radius=0.5, 
                   # popup=~paste("Panels involved in Project:",newcoords[,3]), 
                   fillOpacity=1, group="Solar Projects") %>%
      setView(lng=-98.58,lat=39.83,zoom=4) %>%
      addLayersControl(baseGroups = c("Potential per person", "Solar potential"),
                    overlayGroups = c("Solar Projects"),
                    options = layersControlOptions(collapsed = F)) %>% hideGroup("Potential per person")
 
#Outputs the map  
  output$mapx <- renderLeaflet({
    test
  })
 
  #Q on first page
  output$ansQQ1<- reactive({
    validate( need(input$QQ1, "Select an answer") )
    if (input$QQ1=="9.8%"){answer<- "Correct!"}
    else{answer<-"Incorrect"}
    return(answer)
  })
  
  #makes the clicking on the leaflet map reactive and able to output Cumulative Prob
  #graph and text output
  tmpcnty <- reactive({ input$mapx_shape_click})
  
  #controls the multiple choice question (p2)
  output$ansQ1<- reactive({
    validate( need(input$Q1, "Select an answer") )
    if (input$Q1==1){answer<- "Correct! Solar Potential is a directly related to the average amoutnof sunlight, 
    which is based on weather patterns and geography."}
    else{answer<-"Incorrect"}
    return(answer)
  })
  #Answer to Q2
  output$ansQ2<- reactive({
    validate( need(input$Q2, "Select an answer") )
    if (input$Q2==3){answer<- "Correct! In 2014 the Solar Energy Industry reached a record 34% growth as compares to 2013, 
    to install nearly 7000 megawatts of solar electric capacity."}
    else{answer<-"Incorrect"}
    return(answer)
  })
  data <-  reactive({m1$MEAN[which(m1$COUNTYNS == as.character(tmpcnty()$id))]})
  renderPrint({ecdf(m1$MEAN[data])})
  #Text Output that prints out the solar potential for each county based on the mouse click. 
  output$text<- renderText({ validate(need(input$mapx_shape_click>0, "Select a county from the 'solar potential' map"))
    paste("The solar potential for", (m1$NAME[which(m1$COUNTYNS == as.character(tmpcnty()$id))]), "County is in the", round(cdf(data())*100,1) ,"percentile of solar potential the United States.")
  })  
  output$text2 <- renderText({
    paste("Click a county from the Solar Potential Map to see where it falls on the plot below.")
  })
  
 #renders the Cummulative probability plot for solar potential  
  output$plot<- renderPlot({
    data <-   m1$MEAN[which(m1$COUNTYNS == as.character(tmpcnty()$id))]
    plot(ecdf(m1$MEAN), main="Ranking of Solar Potential in the US", xlab="Solar Energy In (DNI)", ylab="Relative potential")
    abline(v=data , lwd=2, col="purple")
  })

})