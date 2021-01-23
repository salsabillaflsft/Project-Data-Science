library(shiny) #Web Application Framework for R
library(shinythemes) #Themes for Shiny 

# Load data
dataCleanedBiden <- read.csv("~/Project-Data-Science/dataCleanedBiden.csv")
dataCleanedTrump <- read.csv("~/Project-Data-Science/dataCleanedTrump.csv")
dataSentimenBiden <- read.csv("~/Project-Data-Science/dataSentimenBiden.csv")
dataSentimenTrump <- read.csv("~/Project-Data-Science/dataSentimenTrump.csv")

#source to functions used
source("~/Project-Data-Science/sentimen_analysis_tweet_141_144.R")

# Define UI for application 
ui <- fluidPage(theme = shinytheme("flatly"),
                
    headerPanel("Analisis Sentimen Tweet Replies"),
    headerPanel("pada akun Donald Trump dan Joe Biden dengan Naive Bayes"),
    
        mainPanel(
            tabsetPanel(
                tabPanel("Data Twitter Biden", DT::dataTableOutput('dataBiden')),
                tabPanel("Data Twitter Trump", DT::dataTableOutput('dataTrump')),
                tabPanel("Data Cleaned Biden", DT::dataTableOutput('dataCleanedBiden')),
                tabPanel("Data Cleaned Trump", DT::dataTableOutput('dataCleanedTrump')),
                tabPanel("Data Sentimen Biden", DT::dataTableOutput('dataSentimenBiden')),
                tabPanel("Data Sentimen Trump", DT::dataTableOutput('dataSentimenTrump')),
                tabPanel("Sentiment Analysis (Emotion) Plot", plotOutput("plot1")),
                tabPanel("Sentiment Analysis (Polarity) Plot", plotOutput("plot2"))
            )
        )
)
 
# Define server logic 
server <- function(input, output) {
    dataBiden <- data.frame(dataBiden)
    dataTrump <- data.frame(dataTrump)
    dataCleanedBiden <- data.frame(dataCleanedBiden)
    dataCleanedTrump <- data.frame(dataCleanedTrump)
    dataSentimenBiden <- data.frame(dataSentimenBiden)
    dataSentimenTrump <- data.frame(dataSentimenTrump)
    
    # Output Data
    output$dataBiden = DT::renderDataTable({
        DT::datatable(dataBiden, options = list(lengthChange = FALSE))
    })
    output$dataTrump = DT::renderDataTable({
        DT::datatable(dataTrump, options = list(lengthChange = FALSE))
    })
    output$dataCleanedBiden = DT::renderDataTable({
        DT::datatable(dataCleanedBiden, options = list(lengthChange = FALSE))
    })
    output$dataCleanedTrump = DT::renderDataTable({
        DT::datatable(dataCleanedTrump, options = list(lengthChange = FALSE))
    })
    output$dataSentimenBiden = DT::renderDataTable({
        DT::datatable(dataSentimenBiden, options = list(lengthChange = FALSE))
    })
    output$dataSentimenTrump = DT::renderDataTable({
        DT::datatable(dataSentimenTrump, options = list(lengthChange = FALSE))
    })
    output$plot1 <- renderPlot({
        ggarrange(plot1, plot2 , 
                  ncol = 1, nrow = 2)
    })
    output$plot2 <- renderPlot({
        ggarrange(plot3, plot4 , 
                  ncol = 1, nrow = 2)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
