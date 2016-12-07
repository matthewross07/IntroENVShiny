
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)

shinyUI(fluidPage(
  navbarPage("The Complexities of Sea Level Change",
      tabPanel("Intro", 
               h3(em("Is sea level rising?"), style="color:darkcyan"),
               fluidRow(
                 column(6, "Sea level is rising ", strong("at an increasing rate"), br(), br(),
                        p("With the majority of Americans living in coastal states, rising water levels can have potentially large impacts.",
                          "There is strong evidence that global sea level is now rising at an increased rate and will continue to rise during this century.",
                          "While studies show that sea levels changed little from AD 0 until 1900, sea levels began to climb in the 20th century.",
                          "Sea level has been steadily rising at a rate of ", "0.04 to 0.1 inches per year since 1900 (NOAA)"),
                        
                        p("This rate may be increasing. Since 1992, new methods of satellite altimetry (the measurement of elevation or altitude) indicate a rate of rise of 0.12 inches per year.
    This is a significantly larger rate than the sea-level rise averaged over the last several thousand years (NOAA). "),
                        
                        
                        h3(em("What is causing sea levels to rise?"), style="color:darkcyan"),
                        strong("The two major causes of global sea-level rise are ", strong("thermal expansion "),  "caused by the warming of the oceans (since water expands as it warms) and the ", strong("loss of land-based ice "),  "(such as glaciers and polar ice caps) due to increased melting."),
                        "Thermal expansion is caused by the warming of the oceans (since water expands as it warms).", 
                        "Thermal expansion and melting each account for about half of the observed sea level rise, and each caused by recent increases in global mean temperature. For the period 1961-2003, the observed sea level rise due to thermal expansion was 0.02 inches per year and 0.3 inches per year due to total glacier melt (small glaciers, ice caps, ice sheets). Between 1993 and 2003, the contribution to sea level rise increased for both sources to 1.60 millimeters per year and 1.19 millimeters per year respectively (IPCC 2007).",
                        br(),br(),
                        h3(em("Pre-Test (keep scrolling down until you have completed all the questions)"), style="color:darkcyan"),
                        radioButtons("q1","Does sea level rise evenly around the globe?", choices = c("Yes","No"), selected= F),
                        br(),
                        h4(textOutput("ans1"), style="color:darkcyan"),
                        br(),br()),
                 column(6, img(src="slr.jpg" ))),
      conditionalPanel("output.ans1=='Correct. This relationship will be explored later in this module'", radioButtons("q2","Does the loss of ice and snow cover accelerate global warming?", choices = c("Yes", "No"), selected=F), br(),
                   h4(textOutput("ans2"),style="color:darkcyan"), br(),br()),
               
      conditionalPanel("output.ans2=='Correct, it is part of a positive feedback loop'", radioButtons("q3", "Does melting of sea ice contribute to sea level rise?", choices = c("Yes","No"), selected = F),
                                h4(textOutput("ans3"), style="color:darkcyan")),

      conditionalPanel("output.ans3=='Correct. Ice floating in water displaces exactly the same volume of water that it is made up of. As it melts, the water level stays the same.'", 
                       radioButtons("q4", "Does melting of land ice contribute to sea level rise?", choices = c("Yes","No"), selected = F),
                       h4(textOutput("ans4"), style="color:darkcyan")),
      conditionalPanel("output.ans4=='Correct. Ice melt from land will raise sea level because of the additional volume added'", 
                       h2("Continue to the interactive sea level map at the top menu", style="color:blue")
      )),
      tabPanel("Interactive", 
               fluidRow(
                  
#                  column(2,  h4("Include Sea Ice Data?"),
#                         checkboxInput("ice", label= "Compare to global sea ice extent", value=F)),
                 column(4, h2("US Sea Level Trends"),
                        h5(em("Why do you think there is so much variation in sea level?")),
                        "Use the interactive map below to explore different sea monitoring stations",
                        br(),br(),
                        leafletOutput("map", height=400)),
                 column(5, br(),br(), plotOutput("trendPlot")),
                 column(3, h2("Find these trends"),
                        textInput("q5", "What is the trend for Juneau, Alaska?"),
                        h4(textOutput("a5"), style="color:darkcyan"), br(),
                        textInput("q8", "What is the trend for San Diego, CA"), 
                        h4(textOutput("a8"), style="color:darkcyan"), br(),
                        textInput("q7", "What is the trend for Grande Isle, LA"), 
                        h4(textOutput("a7"), style="color:darkcyan"), br(),
                        textInput("q6", "What is the trend for Washington, DC"), 
                        h4(textOutput("a6"), style="color:darkcyan"), br(),br(),br(),br()
                        ),
                
               
conditionalPanel("input.map_marker_click", 
  column(6,h2("Why does sea level not rise evenly?"), br(),
     h4(em("Isostasy: Vertical Land Motion")),
    p("The variations in sea level trends seen here primarily reflect differences in rates and sources of vertical land motion, called iostasy (NOAA)."),
    p("Isostasy is the equilibrium that exists between parts of the earth's crust, which behaves as if it consists of blocks floating on the underlying mantle, rising if material (such as an ice cap) is removed and sinking if material is deposited."), br(),
    img(src="iostasy.jpg"), br(),
    "Weight, such as ice, causes the crust to depress and therefore displace mantle that was under it (a). Once the pressure of the weight is removed (or metls), the crust rebounds into equilibrium (b) and (c). ", br(), br(),
    br(),"Image from ", a("Emporia State University", href='http://academic.emporia.edu/aberjame/student/barker3/isostasy.jpg'), br(),
    "More information on this topic can be found on NOAA's ", a("website", href='http://tidesandcurrents.noaa.gov/sltrends/slrmap.htm'), br()
    ), 
  column(6, h3("Vertical Land Motion and sea level rise"),
     p("- Stations experiencing little-to-no change in mean sea level will fall in the range of 0 to 3 mm/yr (yellow), including stations consistent with average global sea level rise rate of 1.7-1.8 mm/yr. These are stations not experiencing significant vertical land motion (NOAA)."),
     p("- Stations with positive sea level trends (3 to 12 mm/yr, reds & oranges) are experiencing both global sea level rise, and lowering or sinking of the local land, causing an apparently exaggerated rate of relative sea level rise (NOAA)."),
     p("- Stations with negative trends (-6 to -12 mm/yr, greens & blues) are experiencing global sea level rise and a greater vertical rise in the local land, causing an apparent decrease in relative sea level (NOAA)."), br(), br(), br(),
     "All data comes from NOAA's open online database of sea level trends", br(), br(),
     "This application was created by Molly Rosenstein as a part of the",
a(href="http://bigdata.duke.edu/data", "Duke Data+"),
"Interactive Environmental Data Team", br(),br(),
     h4("Interested in the social impacts of this topic? Check out ", a("this study",href="http://ss2.climatecentral.org/#5/38.874/-86.089?show=satellite&level=4&pois=hide"))
     ) )           
    )
    )
       
  
  )
  )
  )
