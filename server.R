# WorldCloud - educational app for Coursera - Developing Data Products Course
# Week4 - Peer-graded Assignment: Course Project: Shiny Application and Reproducible Pitch
# server.r file
# pduchesne 03-FEB-2018

# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
shinyServer(function(input, output, session) {
        # Define a reactive expression
        cities <- eventReactive(input$update,{ # Change when the "Display" button is pressed...
                subset(df_mrg, Country == input$country, 
                       select = c(AccentCity, Population, lat, lng)
                       )
                        })
output$WCloud <- renderPlot({
        ct<-cities()
        par(mar = c(0,0,0,0))
        wordcloud(words=ct$AccentCity, # Cities
                  freq=ct$Population, # Population
                  scale = c(3,.2), # size of largest and smallest words
                  max.words=100,
                  colors=brewer.pal(8, "Dark2"), # number of colors, palette
                  rot.per=0.35) # proportion of words to rotate 90 degrees
                })
        

output$citytable <- DT::renderDataTable({
        ct<-cities()
        ct<-select(ct,City=AccentCity,Population)
        ct<-ct %>% arrange(desc(Population))
        DT::datatable(ct[drop = FALSE])
})
output$MapCities <- renderLeaflet({ #initial blank display
        ct <- cities()
        leaflet() %>%
        addTiles() %>%
        clearBounds()
})
observe({
        ct <- cities()
        leafletProxy("MapCities") %>% clearMarkers() %>% 
                fitBounds(max(ct$lng),max(ct$lat),min(ct$lng),min(ct$lat)) %>% 
                addTiles() %>% 
                addCircles(lng = ct$lng,
                                 lat = ct$lat,
                                 weight = 1, radius = sqrt(ct$Population) * 30)
})

})
