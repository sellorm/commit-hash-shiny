#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)

# Use the Connect API to obtain the source commit hash for the app
api_url <- paste0(Sys.getenv("CONNECT_SERVER"),
                  "__api__/v1/content/",
                  Sys.getenv("CONNECT_CONTENT_GUID"),
                  "/bundles")
apiKey <- Sys.getenv("CONNECT_API_KEY")
bundle <- GET(api_url,
              add_headers(Authorization = paste("Key", apiKey)))


api_info <- list(
  git_output = content(bundle, "parsed")[[1]]$metadata$source_commit,
  github_url = paste0("https://github.com/sellorm/commit-hash-shiny/commit/",
                      content(bundle, "parsed")[[1]]$metadata$source_commit),
  bundle_id = content(bundle, "parsed")[[1]]$id,
  bundle_url = paste0(Sys.getenv("CONNECT_SERVER"),
                      "/__api__/v1/experimental/bundles/",
                      content(bundle, "parsed")[[1]]$id,
                      "/download")
)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Geyser Data (with Git commit hash and Bundle ID)"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            "Git commit hash:",
            a(href=api_info$github_url, substr(api_info$git_output, 1, 7)),
            br(),
            "Bundle ID:",
            a(href=api_info$bundle_url, api_info$bundle_id),
            ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    output
}

# Run the application
shinyApp(ui = ui, server = server)
