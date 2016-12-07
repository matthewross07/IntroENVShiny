library(shiny)
pltsz <- "100px"

shinyUI(fluidPage(
  tags$head(tags$style("#textblue2{color: red;
                                 font-style: italic;
                                 }"
  )),
  tags$head(tags$style("#textgreen2{color: red;
                                 font-style: italic;
                                 }"
  )),
  tags$head(tags$style("#textgrey2{color: red;
                                 font-style: italic;
                                 }"
  )),
  
navbarPage( "Water Footprints",
 tabPanel("Overview",
  headerPanel('ENVIRON102 and the rest of the world'),
#       fluidRow(
#         column(3,br(),),
#         column(5,),
# #        column(2,br(),actionButton("check","Enter")),
#         column(5,)
#       ),
#       hr(),
#      conditionalPanel("output.confirm2 == ' '",
        fluidRow(
          sidebarLayout(
            sidebarPanel(
              strong("Choose which footprints to display:"),
              checkboxInput(inputId = "green",label = strong("Green"),value=TRUE),
              checkboxInput(inputId = "blue",label = strong("Blue"),value=TRUE),
              checkboxInput(inputId = "grey",label = strong("Grey"),value=TRUE),
              strong("Enter username (optional):"),
              textInput("username2",""),
              textOutput("confirm2")
            ),
            mainPanel(
              h4("Below, the box and whisker plots are average data from all countries in the world.  The vertical bold Duke blue line is our average class value (the dashed vertical lines are the uncertainty)."),
              conditionalPanel("input.green",
                               h3("Green water footprint"),
                               plotOutput("plotgreen",height=pltsz),
                               textOutput("textgreen"),
                               conditionalPanel("output.confirm2 == ' '",textOutput("textgreen2")),
                               hr()
              ),
              conditionalPanel("input.blue",
                               h3("Blue water footprint"),
                               plotOutput("plotblue",height=pltsz),
                               textOutput("textblue"),
                               conditionalPanel("output.confirm2 == ' '",textOutput("textblue2")),
                               hr()
              ),
              conditionalPanel("input.grey",
                               h3("Grey water footprint"),
                               plotOutput("plotgrey",height=pltsz),
                               textOutput("textgrey"),
                               conditionalPanel("output.confirm2 == ' '",textOutput("textgrey2"))
              )
            )
          )
        )
      #)            
    ),
 tabPanel("Our class",
          plotOutput("plotclass",height=400),
          h4(strong("For discussion:"), "Did you expect the groupings above to be different from each other? Why or why not? (hint: see Chapter 12 in text)"),
          hr(),
          plotOutput("barclass")
 ),
 tabPanel("Maps",
          h3(textOutput("textcntry")),
          
          h4(strong("For discussion:"), "Compare the distribution of grey, blue, and green water footprints around the world."),
          p(HTML("Using the maps below and <a href='https://goo.gl/w7gkrh'>this data table</a>, answer the following questions. 
                <ol>
                  <li>How much of the water footprint for people in your chosen country comes from consumption of agricultural products?</li>
                  <li>What are some possible reasons for the footprint differences between your chosen country and the United States?</li>
                  <li>Which footprint grouping (grey, blue, green) is most concerning to you for sustainable water use? Why?</li>
                 </ol>")),
          p(HTML("Larger maps can be seen in the additional tabs <a href='https://goo.gl/w7gkrh'>with the data table</a>.")),
          
          h3("Green water footprint"),
          tags$div(HTML(
            "<iframe src='https://docs.google.com/spreadsheets/d/13VKJ6gUBxdcWpYdKb0UC7ZR4il04XLEF4SezsU_jKPU/pubchart?oid=1663321744&amp;format=interactive' width=605 height=375></iframe>"
          )),
          h3("Blue water footprint"),
          tags$div(HTML(
            "<iframe src='https://docs.google.com/spreadsheets/d/13VKJ6gUBxdcWpYdKb0UC7ZR4il04XLEF4SezsU_jKPU/pubchart?oid=486205747&amp;format=interactive' width=605 height=375></iframe>"
          )),
          h3("Grey water footprint"),
          tags$div(HTML(
            "<iframe src='https://docs.google.com/spreadsheets/d/13VKJ6gUBxdcWpYdKb0UC7ZR4il04XLEF4SezsU_jKPU/pubchart?oid=1044319336&amp;format=interactive' width=605 height=375></iframe>"
          ))
          
          )
  )
))
