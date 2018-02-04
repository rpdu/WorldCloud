# WorldCloud - educational app for Coursera - Developing Data Products Course
# Week4 - Peer-graded Assignment: Course Project: Shiny Application and Reproducible Pitch
# ui.r file
# pduchesne 03-FEB-2018
shinyUI(fluidPage(
        
        # Application title
        img(src='worldcloud3.png'),
        titlePanel(" Countries & Cities by Population"),
        fluidRow(
                column(4,
                       helpText("Use dropdown list box to select a contry."),
                       selectInput("country", "Select Country:", choices = countries ),
                       helpText("Click Display button to dislay/refresh data."),
                       actionButton("update", "Display"),
                       br(),
                       h3("WorLd Cloud - Cities by Population"),
                       plotOutput("WCloud"),
                       helpText("Maximise display window for best view."),
                       helpText("This product includes data created by MaxMind, available from http://www.maxmind.com/")
                ),
                column(8,
                       tabsetPanel(
                               tabPanel("Map View",leafletOutput("MapCities",width = "100%", height = 700)),
                               tabPanel("Detail Data",DT::dataTableOutput("citytable"))         
                       )
                )
        )
)
)
