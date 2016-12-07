library(shiny)
library(rgdal)
library(leaflet)

shinyUI(fluidPage(
  navbarPage(
    "Solar Potential",
    tabPanel("Intro",
    fluidRow( 
             column(5, h3("Renewable Resources: Solar Energy"), br(),
                    p("Solar energy is a free and infinitely renewable resource. Its use does not directly produce 
                       local air pollutants or greenhouse gases. Solar PV panels, which convert light energy into electricity, can be installed almost anywhere—on the roofs or walls 
                       of homes and businesses, in vast solar photovoltaic farms in the desert, or in remote locations where there is no 
                       connection to the electric power grid. The energy from the sun can also be used to heat water on rooftops, 
                       later to be used to heat water or the building itself."),
              
p("However, solar energy is diffuse and unevenly 
                distributed around the globe; its availability also varies with the seasons 
                and weather. The main challenge facing the use of solar energy is the development 
                of economical ways to capture, convert, and store it. Used in conjunction with other forms of
                renewable resources, however, solar energy could make a significant contribution towards the 
   effort to decrease dependence on fossil fuels. Energy efficiency and energy conservation are also important factors to consider."), br(),
                    radioButtons("QQ1", "How much of the energy used in the US in 2014 came from renewable resources?", 
                                 choices= c("25.4%", "13.3%", "9.8%"), selected = F), 
                    h5(textOutput("ansQQ1"), style="color:blue"), 
                    p( a("Energy Information Administration", href= "http://www.eia.gov/totalenergy/data/monthly/pdf/sec1_7.pdf"), style= "font-size:80%")
                    ), 
              column(7, img(src="SP.jpg", height= 300, width= 600), 
                     p("Image from: http://cdn.phys.org/newman/gfx/news/hires/2013/neutroninves.jpg", style= "font-size:80%"),
                     br(), 
                     img(src="sel_pyramid.jpg", height = 400, width=600), 
                     p("Image from: http://www.proactivewaterworks.com/tellerenergy/wp-content/uploads/2011/07/sel_pyramid.jpg"), style= "font-size:80%")
                                      
    )),
    tabPanel("U.S. Solar Potential",
    fluidRow(
      sidebarPanel(
        h3("Thinking Questions:"),
        radioButtons(
          "Q1", 'Why do you think that states in the Southwest seem to have a higher potential for solar?',
          choices = c("The area receives more sunlight"=1, " The area has a small population"=2, "The area has more infrastructure to build solar panels"=3), selected=F
        ),
        h5(textOutput("ansQ1"), style="color:blue"),
        
        radioButtons(
          "Q2", 'How much has the US solar industry grown between 2013 and 2014? (hint: try Google or the SEIA)',
          choices = c("7%"=1, "20%"=2, "34%"=3), selected=F
        ),
        h5(textOutput("ansQ2"), style="color:blue"),

        p(strong('Why are there no recorded solar projects in New Jersey?')),
        p(strong('Why are there so many recorded solar projects in Western Oregon, despite having low solar input?')),
                
        p( a("Solar Energy Industries Association link", href= "http://www.seia.org/research-resources/solar-industry-data"), style= "font-size:80%")),
     mainPanel(
      
        leafletOutput("mapx", height= 400), 
                p(em("Data for Map taken from the National Renewable Energy Laboratory and the US Census Bureau."), style="font-size:80%"),
                br(),
        h4(textOutput("text"),style="color:darkblue"), br(),
                plotOutput("plot"), height=200,
        "Created by Tess Harper as a part of", a(href='http://bigdata.duke.edu/data', "Duke Data+"), "Interactive Environmental Data Team"
        
     )
     )
            
    )
      ) 
  ))