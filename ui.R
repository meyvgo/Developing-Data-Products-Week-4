#
# This is the user-interface definition of the Shiny web application
# "Births by Month and Day".

library(shiny)

source("app.R")

shinyUI(fluidPage(
    # Application title
    titlePanel("Comparing U.S. Daily Births by Month and Day"),
    
    # Sidebar with input
    sidebarLayout(
        sidebarPanel(
            p(style='color:steelblue',"To use this application, select a month and a day below, and then look at the plots in the Monthly Comparison and Daily Comparison tabs."),
            p(style='color:steelblue',"============================="),
            # Create drop down for user to select a month
            selectInput("monthName", "Select a month:", 
                        c("January", "February", "March", "April", "May", "June",
                          "July", "August", "September", "October", "November", 
                          "December")),
            # Create slider for user to select a day
            sliderInput("sliderVal", textOutput("pickdaymsg"), 1, 31, 1),
            p(style='color:steelblue',"============================="),
            p(style='color:steelblue',"For more detailed information and instructions, go to the Documentation tab.")

        ),
        mainPanel(
            tabsetPanel(type="tabs",
                        tabPanel("Monthly Comparison", br(), htmlOutput("monthmsg", style="font-size:18px"), br(), plotOutput("monthplot"), br(), 
                                 "* Based on a dataset containing the number of daily births in the U.S. from 1994-2014.", br(), 
                                 "** 0% corresponds to the average of the entire dataset, which is 11175 daily births."),
                        tabPanel("Daily Comparison", br(), htmlOutput("daymsg", style="font-size:18px"), br(), plotOutput("dayplot"), br(),
                                 "* Based on a dataset containing the number of daily births in the U.S. from 1994-2014.", br(), 
                                 htmlOutput("dayfootnote")),
                        tabPanel("Documentation", br(), 
                                 paste("This application is based on a data set that provides the number of births in the U.S. per day from 1994 to 2014.",
                                       "The statistical news site FiveThirtyEight.com made the data available "),
                                 a("here", href="https://github.com/fivethirtyeight/data/find/master", target="_blank"), 
                                 "as it was the source for their article ", 
                                 a("'Some People Are Too Superstitious To Have A Baby On Friday The 13th.'", href="https://fivethirtyeight.com/features/some-people-are-too-superstitious-to-have-a-baby-on-friday-the-13th/", target="_blank"),
                                 paste("The original data comes from a combination of the U.S. Centers for Disease Control and Prevention and the U.S. ", 
                                       "Social Security Administration."), br(), br(),
                                 "To use the application,", tags$b("select a month"), "from the drop-down menu, and then", tags$b("pick a day"), "from that month using the slider.",
                                 "For example, try picking your birthday, the birthday of your family members, or your favorite holiday.", br(), br(),
                                 "Once you have selected a month and day, you can:", br(), br(),
                                 tags$ul(
                                     tags$li(tags$b("Go to the Monthly Comparison tab"), paste("to see a chart showing how the average number of births per day for each month",
                                                                                               "compares to the overall average number of births per day for the whole data set.",
                                                                                               "The month you selected will be highlighted and the percent difference in the average",
                                                                                               "number of daily births for that month from the overall average will be stated above the chart.")), br(),
                                     tags$li(tags$b("Go to the Daily Comparison tab"), paste("to see a chart showing how the average number of births for each day in the selected month",
                                                                                             "compares to the overall average number of births per day for that month.",
                                                                                             "The day you selected will be highlighted and the percent difference in the average",
                                                                                             "number of daily births for that day from the overall montly average will be stated above the chart."))
                                 ),
                                 br(), br(), "The code for this application is available here:",
                                 a("https://github.com/meyvgo/Developing-Data-Products-Week-4", href="https://github.com/meyvgo/Developing-Data-Products-Week-4", target="_blank"),
                                 br(), br(), "A presentation about this application is available here:",
                                 a("https://meyvgo.github.io/developing-data-products/week4/index.html#/", href="https://meyvgo.github.io/developing-data-products/week4/index.html#/", target="_blank")
                                 )
                                 
            )
        )
    )
))
