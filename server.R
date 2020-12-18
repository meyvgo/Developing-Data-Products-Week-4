#
# This is the server logic of the Shiny web application "Births by Month and Day".


library(shiny)

shinyServer(function(input, output, session) {
    
    ## Update the max of the day slider depending on the month selected
    observeEvent(input$monthName, {
        maxDay<-ifelse(input$monthName %in% c("April", "June", "September", "November"), 30, 
                       ifelse(input$monthName == "February", 29, 31))
        updateSliderInput(session, "sliderVal", max=maxDay, value=1)
    })  
    
    output$pickdaymsg<-renderText({
        paste0("Select a day in ", input$monthName, ":")
    })
    
    output$monthmsg<-renderText({
        mnum<-which(avg_per_month$month_abbrev==substr(input$monthName,1,3))
        if (avg_per_month$pct_dif[mnum]<0) {
            paste0("Compared to the overall average number of U.S. births per day, the month of ",
              "<span style='color:purple'><b>",input$monthName,"</b></span>", " has an average of ", 
              "<span style='color:purple'><b>",
              abs(round(avg_per_month$pct_dif[mnum],2)), "% fewer", "</b></span>", " births per day.*")
        } else {
            paste0("Compared to the overall average number of U.S. births per day, the month of ",
              "<span style='color:purple'><b>",input$monthName,"</b></span>", " has an average of ", 
              "<span style='color:purple'><b>",
              abs(round(avg_per_month$pct_dif[mnum],2)), "% greater", "</b></span>", " births per day.*")
        }
    })
    
    output$monthplot<-renderPlot({
        ## Reorder the data so our plot comes out with January as the first bar
        avg_per_month<-avg_per_month %>% arrange(desc(month))

        ## Set up colors for the graph
        colors<-rep("lavender", 31)
        
        ## Make the selected month a different color
        colors[which(avg_per_month$month_abbrev==substr(input$monthName,1,3))]<-"purple"
        
        barplot(height=avg_per_month$pct_dif, names=avg_per_month$month_abbrev, horiz=TRUE,
                xlab="Percent", xlim=c(-5,6), col=colors,
                las=1, main="Percent Difference in Average Daily Births By Month \nFrom Overall Average US Daily Births 1994-2014**")
        abline(v=0, col="steelblue", lwd=3)
    })      

    output$daymsg<-renderText({
        dnum<-which(avg_per_day$month_abbrev==substr(input$monthName,1,3) & avg_per_day$date_of_month==input$sliderVal)[1]
        if (avg_per_day$pct_dif[dnum]<0) {
            paste0("<span style='color:purple'><b>", input$monthName, " ", input$sliderVal, "</b></span>",
                   " has an average of ", "<span style='color:purple'><b>",
                   abs(round(avg_per_day$pct_dif[dnum],2)), "% fewer", "</b></span>", 
                   " births per day compared to the average number of U.S. births per day",
                   " in the month of ", input$monthName, ".*")
        } else {
            paste0("<span style='color:purple'><b>", input$monthName, " ", input$sliderVal, "</b></span>",
                   " has an average of ", "<span style='color:purple'><b>",
                   abs(round(avg_per_day$pct_dif[dnum],2)), "% greater", "</b></span>", 
                   " births per day compared to the average number of U.S. births per day",
                   " in the month of ", input$monthName, ".*")
        }
    })
    
    output$dayfootnote<-renderText({
        paste0("** 0% corresponds to the average for all of ", input$monthName, ", which is ", 
               round(avg_per_month$mean[which(avg_per_month$month_abbrev==substr(input$monthName,1,3))],0), " daily births.")
    })
        
    output$dayplot<-renderPlot({
        maxDay<-ifelse(input$monthName %in% c("April", "June", "September", "November"), 30, 
                       ifelse(input$monthName == "February", 29, 31))

        ## Find the data for our month and order it so our plot comes out correctly
        plotdata<-rep(0, maxDay)
        for(i in 1:maxDay) {
                plotdata[i]<-which(avg_per_day$month_abbrev==substr(input$monthName,1,3)&avg_per_day$date_of_month==i)[1]
        }
        plotdata<-rev(plotdata)
        
        ## Set up colors for the graph
        colors<-rep("lavender", maxDay)
        
        ## Make the selected day a different color
        colors[maxDay-input$sliderVal+1]<-"purple"
        
        ## Set the plot title
        title<-paste0("Percent Difference in U.S. Average Births by Day in ", input$monthName, "\nCompared to the ", input$monthName, " Daily Average 1994-2014**")
        barplot(height=avg_per_day[plotdata,]$pct_dif, names=avg_per_day[plotdata,]$date_of_month, horiz=TRUE,
                xlab="Percent", ylab="Day", col=colors, las=1, main=title)
        abline(v=0, col="steelblue", lwd=3)
    })
    
    output$month<-renderText({input$monthName})
    output$day<-renderText({input$sliderVal})

})
