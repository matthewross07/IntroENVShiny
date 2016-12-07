library(shiny)
library(lubridate)
library(magicaxis)

intldat <- read.csv("../FoodVis/NationalDat.csv")
ecblue <- ecdf(intldat$BlueGalDay)
ecgreen <- ecdf(intldat$GreenGalDay)
ecgrey <- ecdf(intldat$GreyGalDay)

foodcat <- read.csv("../FoodVis/fooditems.csv")

meatcat <- foodcat$Name[which(foodcat$Meat==1)]
anicat <- foodcat$Name[which(foodcat$Animal==1)]
bevcat <- foodcat$Name[which(foodcat$Beverage==1)]

dat <- data.frame(user=character(0),blue=numeric(0),green=numeric(0),grey=numeric(0))
datcat <- data.frame(user=character(0),meat=numeric(0),bev=numeric(0),other=numeric(0))
ll <- list.files("../Food/data/")
ff <- ll[grep(".csv",ll)]
for(f in ff){
  fi <- paste("../Food/data/",f,sep="")
#  fi <- paste("Food/data/",f,sep="")
  if( as.numeric(file.info(fi)$size) < 500 ) next
  #if( difftime(now(),file.info(fi)$ctime,units="days")>30 ) next
  # if file is older than 30 days, skip it
  td <- read.csv(fi,header=F)    
  for(i in 3:5) td[,i] <- suppressWarnings(as.numeric(as.character(td[,i])))
  if(any(is.na(td[,3:5]))) td <- td[-which(apply(is.na(td),1,function(x) any(x))),]
  tda <- t(matrix(apply(as.matrix(td[,3:5]),2,sum,na.rm=T)))
  tdat <- data.frame(strsplit(f,"\\.csv")[[1]], tda)
  colnames(tdat) <- c("user","blue","green","grey")
  dat <- rbind(dat,tdat)

  meat <- sum(apply(td[which(td[,1]%in%meatcat),3:5],2,sum,na.rm=T))
  bev <- sum(apply(td[which(td[,1]%in%bevcat),3:5],2,sum,na.rm=T))
  other <- sum(apply(td[which(!td[,1]%in%c(meatcat,bevcat)),3:5],2,sum,na.rm=T))
  tcat <- data.frame(user=strsplit(f,"\\.csv")[[1]],meat,bev,other)
  datcat <- rbind(datcat,tcat)  
}

shinyServer(function(input, output) {

#  user2 <- eventReactive(input$check, return(input$username2) )
  output$confirm2 <- renderText({
    filename2 <- paste("../Food/data/",input$username2,".csv",sep="")
    filetrue <- file.exists(filename2)
    if(!file.exists(filename2)) paste("User does not Exist")
    else{
      return(" ")
    }
  })
  
  output$plotblue <- renderPlot({
    par(mar=c(4,3,0,0))
    if(input$username2!=""){usrval <- dat$blue[which(dat$user==input$username2)]}else{usrval <- -9999}
    boxplot(intldat$BlueGalDay,log="x",range=0,xaxt="n",lty=1,staplewex=0,horizontal=T,
            ylim=c(min(intldat$BlueGalDay),max(c(intldat$BlueGalDay,usrval))) )
    magaxis(1,las=1,xlab="Blue water footprint (gallons / person / day)")
    abline(v=mean(dat$blue),lwd=3,col="#001A57")
    abline(v=mean(dat$blue)+sd(dat$blue)/nrow(dat),lty=2,col="#001A57")
    abline(v=mean(dat$blue)-sd(dat$blue)/nrow(dat),lty=2,col="#001A57")
    abline(v=usrval,lwd=2,col="red")
  })
  output$plotgreen <- renderPlot({
    par(mar=c(4,3,0,0))
    if(input$username2!=""){usrval <- dat$green[which(dat$user==input$username2)]}else{usrval <- -9999}
    boxplot(intldat$GreenGalDay,log="x",range=0,xaxt="n",lty=1,staplewex=0,horizontal=T,
            ylim=c(min(intldat$GreenGalDay),max(c(intldat$GreenGalDay,usrval))) )
    magaxis(1,las=1,xlab="Green water footprint (gallons / person / day)")
    abline(v=mean(dat$green),lwd=3,col="#001A57")
    abline(v=mean(dat$green)+sd(dat$green)/nrow(dat),lty=2,col="#001A57")
    abline(v=mean(dat$green)-sd(dat$green)/nrow(dat),lty=2,col="#001A57")
    abline(v=usrval,lwd=2,col="red")
  })
  output$plotgrey <- renderPlot({
    par(mar=c(4,3,0,0))
    if(input$username2!=""){usrval <- dat$grey[which(dat$user==input$username2)]}else{usrval <- -9999}
    boxplot(intldat$GreyGalDay,log="x",range=0,xaxt="n",lty=1,staplewex=0,horizontal=T,
            ylim=c(min(intldat$GreyGalDay),max(c(intldat$GreyGalDay,usrval))) )
    magaxis(1,las=1,xlab="Grey water footprint (gallons / person / day)")
    abline(v=mean(dat$grey),lwd=3,col="#001A57")
    abline(v=mean(dat$grey)+sd(dat$grey)/nrow(dat),lty=2,col="#001A57")
    abline(v=mean(dat$grey)-sd(dat$grey)/nrow(dat),lty=2,col="#001A57")
    abline(v=usrval,lwd=2,col="red")
  })
  output$plotclass <- renderPlot({
    sumdat <- apply(datcat[,c(2,4)],1,sum)
    herbs <- rep(0,nrow(datcat))
    herbs[which(datcat$meat==0)] <- 1
    boxplot(sumdat~herbs,names=c("Omnivore","Vegetarian"),range=0,xaxt="n",lty=1,staplewex=0,horizontal=T,log="x",bty="n",main="Differences in diet, food water footprints")
    magaxis(1,las=1,xlab="Water footprint (gallons / person / day)")
  })
  output$barclass <- renderPlot({
    bars <- apply(datcat[,2:4]/apply(datcat[,2:4],1,sum),2,mean)
    barplot(bars[c(3,1,2)]*100,names.arg=c("Vegetables","Animal products","Beverages"),ylab="Percent of footprint",las=1,bty="n",main="Footprint distribution of average student in ENV102")
  })
  
  output$textblue <- renderText({
    cblue <- as.character(intldat$Country[which(abs(intldat$BlueGalDay-mean(dat$blue))==min(abs(intldat$BlueGalDay-mean(dat$blue))))]) # find closest value.
    prc <- floor(ecblue(mean(dat$blue))*100)
    usprc <- floor(100*mean(dat$blue)/intldat$BlueGalDay[which(intldat$Country=="USA")])
    paste("Our average blue water footprint is closest to that of people in ",cblue," and is greater than ",prc,"% of other countries. It is ",usprc,"% of the average American's footprint.",sep="")
    })
output$textgreen <- renderText({
  cgreen <- as.character(intldat$Country[which(abs(intldat$GreenGalDay-mean(dat$green))==min(abs(intldat$GreenGalDay-mean(dat$green))))]) # find closest value.
  prc <- floor(ecgreen(mean(dat$green))*100)
  usprc <- floor(100*mean(dat$green)/intldat$GreenGalDay[which(intldat$Country=="USA")])
  paste("Our average green water footprint is closest to that of people in ",cgreen," and is greater than ",prc,"% of other countries. It is ",usprc,"% of the average American's footprint.",sep="")
})
output$textgrey <- renderText({
  cgrey <- as.character(intldat$Country[which(abs(intldat$GreyGalDay-mean(dat$grey))==min(abs(intldat$GreyGalDay-mean(dat$grey))))]) # find closest value.
  prc <- floor(ecgrey(mean(dat$grey))*100)
  usprc <- floor(100*mean(dat$grey)/intldat$GreyGalDay[which(intldat$Country=="USA")])
  paste("Our average grey water footprint is closest to that of people in ",cgrey," and is greater than ",prc,"% of other countries. It is ",usprc,"% of the average American's footprint.",sep="")
})
output$textblue2 <- renderText({
  if(input$username2!=""){usrval <- floor(dat$blue[which(dat$user==input$username2)])}else{usrval <- ""}
  paste("Your value was",usrval,"gallons per day")
})
output$textgreen2 <- renderText({
  if(input$username2!=""){usrval <- floor(dat$green[which(dat$user==input$username2)])}else{usrval <- ""}
  paste("Your value was",usrval,"gallons per day")
})
output$textgrey2 <- renderText({
  if(input$username2!=""){usrval <- floor(dat$grey[which(dat$user==input$username2)])}else{usrval <- ""}
  paste("Your value was",usrval,"gallons per day")
})


output$textcntry <- renderText({
  paste("Your randomly chosen country is ",as.character(sample(intldat$Country,1)))
})


})