string_database_view <-function() {
  
  tabPanel("String Database",
           tags$h3("Gene Information: "),
           DT::dataTableOutput("string"),
           tags$br(),
           tags$hr(),
           tags$h3("Setting: "),
           tags$div(id="string_setting", class="row",
             tags$div(class="col col-sm-3", 
                      selectInput("network_flavor", "Meaning of Network Edges", choices=c("confidence", "evidence", "actions"), selected = "actions", multiple = FALSE,
                         selectize = TRUE, width = NULL, size = NULL)),
             tags$div(class="col col-sm-3",
                      selectInput("requried_score", "Minimum Required Interaction Score", choices=c("900", "700", "400", "150"), selected = "400", multiple = FALSE,
                         selectize = TRUE, width = NULL, size = NULL)),
             tags$div(class="col col-sm-3",
                      selectInput("addInteractor1", "Max Number of Interactors to Show (1st shell)", choices=c("5", "10", "20", "50"), selected = "10", multiple = FALSE,
                         selectize = TRUE, width = NULL, size = NULL)),
             tags$div(class="col col-sm-3",
                      selectInput("addInteractor2", "Max Number of Interactors to Show (2nd shell)", choices=c("0", "5", "10", "20", "50"), selected = "0", multiple = FALSE,
                         selectize = TRUE, width = NULL, size = NULL))
           ),
           actionButton("updateString", 'Update'),
           tags$div(id = "string_result", class="row",
                    tags$div(id="string_svg", class="col col-sm-8",
                             uiOutput("svg")),
                    tags$div(id="string_network", class="col col-sm-4",
                             htmlTemplate("network_data_table.html"),
                             tags$div(id="network_table", class="collapse",
                             dataTableOutput("string_network_table")))
                    ),
           tags$div(id="string_svg_legend", class="col col-sm-12",
                    htmlTemplate("legend.html"),
                    tags$br(),
                    tags$hr()
                    ),
           tags$div(id= "string_pathway",
                    tags$br(),
                    tags$h3("Functional Enrichment Results"),
                    DT::dataTableOutput("string_analysis"),
                    tags$div(id="string_analysis_tables",
                             uiOutput("string_func_dts"))
                    )
           
                     
  )
  
}