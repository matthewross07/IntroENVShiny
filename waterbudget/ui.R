
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


shinyUI(fluidPage(
  
  #titlePanel("Water Budget"),
  
  navbarPage(
    "Water Budget",
    tabPanel("Intro",
             fluidRow(
               column(5, "The data used in this application is from the", 
                      a("Hubbard Brook Ecosystem Study.", href="http://www.hubbardbrook.org/", target="_blank"),
                      h3("Watershed 3- the Control"),
                      'Area: 42.4 ha',br(), 
                      'Mean slope: 12.1° ', br(),
                      'Aspect: S23°W', br(), 
                      'Elevation: 527-732 m',br(), 
                      'Gage type: V-notch weir', br(), 
                      'Initial year: 1957',
                      h5('Treatment:') ,
                      'None', 
                      h5('Comments: '),
                      'Watershed 3 is used as a hydrologic reference watershed.',
                      h3("Watershed 2"),
                      'Area:  15.6 ha',br(),
                      'Mean slope:   18.5°', br(),
                      'Aspect:   S31°E', br(),
                      'Elevation:   503-716 m', br(),
                      'Gage type:   V-notch weir', br(),
                      'Initial year:   1957',
                      
                      h5('Treatment:'),
                      'Devegetated for three years, 1965-1967.',
                      'In December 1965, all the trees and shrubs on Watershed 2 were felled and left in place.',
                      'During the growing seasons of 1966, 1967 and 1968 the watershed herbicides were applied to prevent vegetation regrowth.',
                      h5('Objective:'),
                      'To assess the ecosystem response to deforestation.'),
               column(7, img(src = "hb_slide.gif", height = 400),
                      br(),
                      br(),
                      "Watershed 2", br(),
                      img(src = "watershed5aerial.jpg", height = 400)
               ),
               h2("Continue to Runoff Ratio in the top menu", style="color:blue")
               
             )
    ),
    
    tabPanel(
      "Runoff Ratio",
      tabPanel("About Runoff Ratio",
               br(),
               fluidRow(
                 column(5, 'The term, runoff ratio, is the percent of precipitation that becomes streamflow in a watershed. ', br(), br(),
                        'Values range from 0, meaning all of the precipitation is stored or evapotranspired in the watershed, ',
                        'to 1, meaning all precipitation leaves the watershed as streamflow.', br(),br(),
                        p('Vegetation, especially trees, can both help retain water in a watershed and act as straws to increase rates of evapotranspiration.')
                 )
               ),
               
               radioButtons(
                 "Q1", 'Given this information, what would you expect to see in a watershed that has been deforested?',
                 choices = c("More water leaving the watershed", "No change in water leaving the watershed", "Less water leaving the watershed"), selected=F
               ),
               h4(textOutput("ansQ1"), style="color:blue"), br(),br()
      ),
      conditionalPanel("output.ansQ1 == 'Correct, see below'",
               sidebarPanel(
                 h3('Calculate Yearly Runoff Ratio:'), br(),
                 withMathJax("$$\\text{Runoff Ratio} = \\frac {RunoffDepth}{Precipitation}$$"), br(),
                 "The tables to the right are clickable to help you keep your place", br(), br(),
                 textInput("Q2","To Start-  Calculate the runoff ratio for WS_2 in 1962, enter your answer below:"), br(),
                 h4(textOutput("ansQ2"), style="color:blue")
               ),
               fluidRow(
                 column(3, h3("Runoff Depth (mm/ year)"),
                        helpText("Runoff Depth is the total runoff normalized by area of the watershed"),
                        DT::dataTableOutput("streamYA" )),
                 column(3, h3("Yearly Precip (mm/ year)"), 
                        helpText("Normalized by area of the watershed"),br(),
                        DT::dataTableOutput("precipYA" ))
               )
      ),
      conditionalPanel("output.ansQ2 == 'Correct, see below'",
               fluidRow(
                 column(5, h3("Runoff Ratios per year"),
                        DT::dataTableOutput("runoffratio" )),
                 
                 column(7, br(),br(), br(),plotOutput("plot")),
                 h2("You have completed this module! Now continue to evapotranspiration found in the top menu", style="color:blue")
               )
      )
    ),
        tabPanel("Evapotranspiration",
                 fluidRow(
                 column(3, img(src = "SWC.png", height = 400), br(),
                        "Surface water cycle by Mwtoews", br(),br()),
                 column(4,  "Evapotranspiration (ET) is the sum of evaporation and plant transpiration from the Earth's surface to the atmosphere.",
                        br(), br(), "Although there is no completely accurate way of measuring this, it can be estimated using the formula:", br(), br(),
                        " ET= (Precipitation)+(Groundwater Pumping)-(Stream Output)", br(), br(), br())
                   ),

                 fluidRow(
                   h2('Calculate Evapotranspiration:'), br(),
                   column(4, withMathJax("$$\\text{ET} = {Precipitation}+{Groundwater Pumping}-{Runoff Depth}$$")), br(), br(), br(),
                          sidebarPanel(
                            "In the Hubbard Brook research facility, there is no groundwater pumping, and is therefore 0 in the above equation.",br(),
                            "You can also assume that all water that enters the watershed, eventually leaves, either through evaporation, transpiration, or runoff.",
                            "The tables to the right are clickable to help you keep your place", br(), br(),
                            textInput("Q3","To Start-  Calculate evapotranspiration in WS_2 in 1962, enter your answer below:"), br(),
                            h4(textOutput("ansQ3"), style="color:blue"), br()
                          ),

                   column(4, h3("Precipitation"),
                          DT::dataTableOutput("pr" )),
                   column(4, h3("Runoff Depth"),
                          DT::dataTableOutput("st" )), br(),br()
                 
                 
        )),
        conditionalPanel("output.ansQ3 == 'Correct, see below'",
                 h3("Notice the relationship between evapotranspiration and the runoff ratio"),
                 fluidRow(
                   column(6, plotOutput("etPlot")),
                   column(6, plotOutput("rorPlot")),
                   column(5,  h3("Evapotranspiration Table"), DT::dataTableOutput("ET")),
                   column(1, textOutput("1")),
                   column(5, br(),br(),radioButtons("Q4", "What is the relationship?", choices=c("identical", "inverse", "no relationship"), selected=FALSE),
                          h4(textOutput("ansQ4"), style="color:blue")))),
        conditionalPanel("output.ansQ4 == 'Correct, see below'",
                         h2("Congratulations! You have completed this lesson", style="color:blue"), br(),
                         h5("Created by Tess Harper and Molly Rosenstein as a part of Duke Data+ Interactive Environmental Data Team")
                         )
                 
  )))



#         tabPanel("plotly", 
#                  checkboxGroupInput("wsSelect", label="Plot What", choices=c('WS_2', 'WS_3'), selected=c('WS_2', 'WS_3')),
#                  graphOutput("RiverDis"), 
#                  graphOutput("RainVol"),
#                  textOutput("Solution")
#                  
#         )),
#         navbarMenu("plotly",
#         tabPanel("testing", 
#                  checkboxGroupInput("wsSelect", label="Plot What", choices=c('WS_2', 'WS_3'), selected=c('WS_2', 'WS_3')),
#                    graphOutput("trendPlot")
#                    )
#         
#       )

