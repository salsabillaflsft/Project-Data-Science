library(shiny)

# Load data
dataBiden <- read.csv("~/Project-Data-Science/Bidenall.csv")
dataTrump <- read.csv("~/Project-Data-Science/Trumpall.csv")
dataCleanedBiden <- read.csv("~/Project-Data-Science/dataCleanedBiden.csv")
dataCleanedTrump <- read.csv("~/Project-Data-Science/dataCleanedTrump.csv")
dataSentimenBiden <- read.csv("~/Project-Data-Science/dataSentimenBiden.csv")
dataSentimenTrump <- read.csv("~/Project-Data-Science/dataSentimenTrump.csv")


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Analisis Sentimen Biden vs Trump dengan Naive Bayes"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
       sidebarPanel(
        ),

    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
            tabPanel("Data Twitter Biden", DT::dataTableOutput('dataBiden')),
            tabPanel("Data Twitter Trump", DT::dataTableOutput('dataTrump')),
            tabPanel("Data Cleaned Biden", DT::dataTableOutput('dataCleanedBiden')),
            tabPanel("Data Cleaned Trump", DT::dataTableOutput('dataCleanedTrump')),
            tabPanel("Data Sentimen Biden", DT::dataTableOutput('dataSentimenBiden')),
            tabPanel("Data Sentimen Trump", DT::dataTableOutput('dataSentimenTrump')),
            tabPanel("Plot Tweet Biden", plotOutput("plot1")),
            tabPanel("Plot Tweet Trump", plotOutput("plot2"))
        )
    )
   )
)
 
# Define server logic required to draw a histogram
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
    
}

# Run the application 
shinyApp(ui = ui, server = server)
