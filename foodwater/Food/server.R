library(shiny)
library(DT)

#load("foodwater.Rdata")
foodwater <- read.csv("foodwater.csv")

shinyServer(function(input, output) {
  user <- eventReactive(input$save, return(input$username) )
  output$confirm <- renderText({
    # need to have a folder called "data" in the working directory
    filename <- paste("data/",user(),".csv",sep="")
    if(file.exists(filename)){
      paste("Username alreay taken, please choose a different ID.")
    }else{
      file.create(filename)
      paste("Success! Don't forget your username:",user())
    }
  })
  
  values <- reactiveValues( df=matrix(NA,nrow=0,ncol=6) )
  loaded <- reactiveValues( df=matrix(NA,nrow=0,ncol=6) )
  
  user2 <- eventReactive(input$check, return(input$username2) )
  output$confirm2 <- renderText({
    filename2 <- paste("data/",user2(),".csv",sep="")
    filetrue <- file.exists(filename2)
    if(!file.exists(filename2)) paste("User does not Exist")
    else return(" ")
  })
  
  # Load stored data
  observeEvent(input$load,{
    loaded$df <- read.csv(paste("data/",user2(),".csv",sep=""),header=F)
  })
  # Add new data
  observeEvent(input$add,{
    newLine <- c(input$itemName, input$num, 
      (input$num*foodwater$Blue[foodwater$Name==input$itemName])/133.5266, 
      (input$num*foodwater$Green[foodwater$Name==input$itemName])/133.5266, 
      (input$num*foodwater$Grey[foodwater$Name==input$itemName])/133.5266,
      as.character(Sys.time())
    )
    values$df <- rbind(values$df, newLine)
    rownames(values$df) <- 1:nrow(values$df)
  })
  # Delete selected data
  observeEvent(input$delete,{
    values$df <- values$df[-which(rownames(values$df)%in%input$waterF_rows_selected),]
    if(!is.matrix(values$df)) values$df <- t(values$df)
    rownames(values$df) <- 1:nrow(values$df)     
  })
  # Save data
  observeEvent(input$finalSave, {
    write.table(values$df, file=paste("data/",user2(),".csv",sep=""), append=T ,sep=",",row.names=F,col.names=F)
    values$df <- matrix(NA,nrow=0,ncol=6)
  })

  # Render added data
  output$waterF <- DT::renderDataTable({
    tmp <- values$df
    colnames(tmp) <- c('Food Name', 'Amount',  'WaterBlue', 'WaterGreen', 'WaterGrey','Timestamp')
    #rownames(tmp) <- NULL
    tmp
  })

  # render saved data
  output$savedF <- DT::renderDataTable({
    tmp <- loaded$df
    colnames(tmp) <- c('Food Name', 'Amount', 'WaterBlue', 'WaterGreen', 'WaterGrey', 'Timestamp')
    #rownames(tmp) <- NULL
    tmp
  })
  

})
