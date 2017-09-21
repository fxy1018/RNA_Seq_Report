report_pathway_view <-function(conditionTable) {
  tabPanel("Pathway",
           mainPanel(
             tabsetPanel(
               tabPanel("KEGG",
                        fluidRow(
                          column(3,
                                 selectInput("keggcondition1",
                                             "Condition 1:",
                                             c("All",
                                               conditionTable$name[-1]
                                               # unique(as.character(keggTable$Comparison))
                                               ),
                                             selected = "All")
                          ),
                          
                          column(3,
                                 selectInput("keggcondition2",
                                             "Condition 2:",
                                             c("All",
                                               conditionTable$name[-(length(conditionTable$name))]
                                               # unique(as.character(keggTable$Comparison))
                                             ),
                                             selected = "All")
                          ),
                          
          
                          column(3,
                                 numericInput("kegg_fdr",
                                              "FDR:",
                                              value = 0.05,
                                              min = 0.00,
                                              max = 1.00,
                                              step = 0.01)
                          )
                          # ,
                          # 
                          # column(3,
                          #        checkboxInput("screted", "Only Show Screted Proteins", value = FALSE, width = "400px")
                          # )
                        
                        ),
                        fluidRow(
                          DT::dataTableOutput("kegg_table")
                        ),
  
                        br(),
  
                        fluidRow(
                          column(4,
                                 downloadButton("downloadKeggTable", label="Download KEGG Pathways Table")
                          )
                        ),
                        br(),
                        fluidRow(
                          #htmlOutput("pathview")
                          imageOutput("pathview")
                        ),
                        br(),
                        fluidRow(
                          DT::dataTableOutput("mappedGene2KEGGTable")
                        )
  
  
               ),
               tabPanel("Reactome",
                        fluidRow(
                          column(3,
                                 selectInput("reactomecondition1",
                                             "Condition 1:",
                                             c("All",
                                               conditionTable$name[-1]
                                               # unique(as.character(reactomeTable$Comparison))
                                               ))
                          ),
                          
                          column(3,
                                 selectInput("reactomecondition2",
                                             "Condition 2:",
                                             c("All",
                                               conditionTable$name[-(length(conditionTable$name))]
                                               # unique(as.character(reactomeTable$Comparison))
                                             ))
                          ),
                          
                          column(3,
                                 numericInput("reactomeFDR",
                                              "FDR:",
                                              value = 0.05,
                                              min = 0.00,
                                              max = 1.00,
                                              step = 0.01)
                          )
                          # ,
                          # 
                          # column(3,
                          #        checkboxInput("screted", "Only Show Screted Proteins", value = FALSE, width = "400px")
                          # )
                        ),
                        br(),
  
                        fluidRow(
                          DT::dataTableOutput("reactome_table")
                        ),
  
                        br(),
                        fluidRow(
                          column(4,
                                 downloadButton("downloadReactomeTable", label="Download Reactome Pathways Table")
                          )
                        ),
  
                        hr(),
                        br(),
                        tags$head(tags$script(src="http://reactome.org/DiagramJs/diagram/diagram.nocache.js")),
                        tags$div(id="diagramHolder",
                                 htmlOutput("reactomePage")
                        ),
                        
                        hr(),
                        br(),
  
                        fluidRow(
                          DT::dataTableOutput("mappedGene2ReactomeTable")
                        )
               )
             )))}
