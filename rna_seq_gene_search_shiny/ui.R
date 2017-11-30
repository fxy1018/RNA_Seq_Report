library(shiny)
library(DT)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # tags$head(
  #   tags$link(rel="stylesheet",
  #             href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css",
  #             integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb",
  #             crossorigin="anonymous"
  #   )
  # ),
  
  navbarPage("RNA-Seq Analysis Gene Search",
     theme=shinytheme("simplex"), 
     # htmlTemplate("www/navbar.html"),
     
     fluidRow(
       column(3, 
              selectizeInput("genes",
                             "Gene:",
                             choices = NULL, 
                             multiple = FALSE, 
                             options = list(placeholder = "select a gene", maxOptions=30, create = FALSE)),
              
              selectizeInput("experiments",
                             "Experiments:",
                             choices = NULL, 
                             multiple = TRUE, 
                             options = list(placeholder = "select a experiment", maxOptions= 30, create = FALSE)),
              
              selectizeInput("conditions",
                             "Conditions:",
                             choices = NULL, 
                             multiple = TRUE, 
                             options = list(placeholder = "select a condition",  create = FALSE)),
              
              actionButton("update", label="Update", icon=icon("hand-pointer-o")),
              
              downloadButton("download", label="Download", icon = icon("download")),
              tags$div(tags$div(id="plot_control_panel")),
              tags$div(id='test_data_flow')
              
              ),
              
       column(9, id = "col_9_report",
              uiOutput("orderPrint"))
     )
    ),
  tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js",
              integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh",
              crossorigin="anonymous"),
  tags$script(src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js",
              integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ",
              crossorigin="anonymous"),
  tags$script(src="https://code.jquery.com/ui/1.12.1/jquery-ui.js")
  )
)
