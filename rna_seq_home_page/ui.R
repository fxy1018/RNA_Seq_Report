library(shiny)
library(DT)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("RNA-Seq Analysis",
             theme=shinytheme("simplex"), 
  # htmlTemplate("www/navbar.html"),

      fluidRow(
        column(2, 
               selectInput(inputId = "experiment", label="Experiment",
                           choices = experiment_table2$Experiment),
               
               actionButton("view_report", label="View Report")
               ),
        column(10, id = "col_9",
               tags$div(id="exp_table_col", 
               tags$h2("Experiment Table"),
               dataTableOutput('experiment_table')))
      )
  )
)

