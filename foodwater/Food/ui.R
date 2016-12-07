library(shiny)

foodwater <- read.csv("foodwater.csv")


shinyUI(fluidPage(
  navbarPage( "Water Footprint Data Entry",
    tabPanel("Intro",
      fluidRow(
        p("Food production is a major use of global freshwater. As part of our class on Tuesday (11/03) we will talk about water footprints and food. To make this more engaging, you have the option to participate by generating data on the water footprint of your own diet for at least one day."),
        h3("How your data will be used"),
        p(strong("In class on Tuesday"), "we will look at data on dietary water footprints from around the world. Your data will be anonymized and aggregated to generate summary statistics for our class. Everyone in the class will be able to see the anonymized data distribution and how it fits with the global data. You will also have the option to view your own personal data points in the distributions if you want."),
        p("Any data you submit will be stored on a Duke web server until after our class meeting on Tuesday. Then it will be permanently deleted before November 17, 2105. Only people with your username will be able to see your raw data. I (Aaron) will also have access to your data, but I promise that I am not going to investigate any individual files. I take your privacy seriously. If you're concerned about privacy, you could create a totally anonymous username."),
        h3("How to participate"),
        p("1. Create a username below (something that you will remember, maybe something anonymous, or your netid)."),p("2. Record what and approximately how much you eat/drink for at least one day before Tuesday."),p("3. Login in under 'Food Calculation' and add your data to the table. You can search for categories by just typing into the text box or with the dropdown menu. If your food is not in the table, you can make your best guess about categories and amounts."),p("4. Once your data table on the 'Food Calculation' looks good, click 'Save and clear data'. Once you save the data, it will no longer be editable."),p("You can add data as often as you'd like (doesn't need to be all at once)."),
        h3("RECORDING PERSONAL FOOD DATA IS TOTALLY OPTIONAL."),
        p(em("If you are not interested in participating in this, you do not need to do anything before class."),"I think the results will be cool. More participation will make our class on Tuesday more interesting. If you have questions or if it is not working, please email me (abb30@duke.edu)."),br(),
        column(5,
          textInput("username", "If you wish to participate, create a User Name"),
          actionButton("save","Submit User Name"),
          textOutput("confirm")
        )
      )
    ),

    tabPanel("Food Calculation",

      fluidRow(
        textInput("username2", "Enter Username:"),
        actionButton("check","Enter"),
        textOutput("confirm2")
      ),p(),

      conditionalPanel("output.confirm2 == ' '",
       fluidRow(
        sidebarLayout(
          sidebarPanel(
            selectizeInput('itemName', 'Find food items',
                           choices = as.character(foodwater$Name),
              options = list(
                placeholder = 'Search items here',
                onInitialize = I('function() { this.setValue(""); }')
              )
            ),
#             selectInput("itemName", "Choose :", 
#                         as.character(foodwater$Name), 
#                         selectize = T, selected = F),
            numericInput("num", "Insert the Amount Consumed (in oz.)",
                         value= 1),
            actionButton("add", label= "Add to table"),
            tableOutput("reference")),
          mainPanel(
            p("Entered data:"),
            DT::dataTableOutput("waterF"),
            actionButton("delete", label="Delete selected entries"),
            actionButton('finalSave', "Save and clear data")
          )
        )
       )
      )
    
    ),
    
    tabPanel("My Saved Data",
      fluidRow(
        p( actionButton("load","Display/reload saved data"),align="center"),
        DT::dataTableOutput("savedF")
      )
             
             
    )
  )
))
    

