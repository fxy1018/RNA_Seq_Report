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
                          ),

                          column(3,
                                 checkboxInput("disease_pathway", "Only Show Disease Pathways", value = FALSE, width = "400px")
                                 
                          )
                        
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
                        fluidRow(style="height:800px;",
                          #htmlOutput("pathview")
                          tags$div(
                            # tags$a(
                            #   imageOutput("pathview"),
                            #   href="http://www.genome.jp/kegg/pathway.html"
                            # )
                            uiOutput("keggPathviewLink")
                            
                          )
                          
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
               ),
               
               tabPanel("STRING (Protein-Protein Interaction)",
                        fluidRow(
                          column(3,
                                 selectInput("stringcondition1",
                                             "Condition 1:",
                                            conditionTable$name[-1]
                                            # unique(as.character(reactomeTable$Comparison))
                                             )
                          ),
                          column(3,
                                 selectInput("stringcondition2",
                                             "Condition 2:",
                                             conditionTable$name[-(length(conditionTable$name))]
                                               # unique(as.character(reactomeTable$Comparison))
                                             )
                          ),
                          
                          column(3,
                                 numericInput("string_gene_cutoff",
                                              "Input Gene FDR(cutoff):",
                                              value = 0.01,
                                              min = 0.00,
                                              max = 1.00,
                                              step = 0.01)
                          ),
                          column(3,
                                 selectInput("string_protein_type",
                                             "Protein Category:",
                                             c("All",
                                               "Secreted Proteins",
                                               "Transporters",
                                               "Transcription Factors",
                                               "sGC pathway"),
                                             selected = "All")
                          )
                        ),
                        fluidRow(
                          column(3,
                                 selectInput("pathway_network_flavor", "Meaning of Network Edges", choices=c("confidence", "evidence", "actions"), selected = "actions", multiple = FALSE,
                                             selectize = TRUE, width = NULL, size = NULL)),
                          column(3, 
                                 selectInput("pathway_requried_score", "Minimum Required Interaction Score", choices=c("900", "700", "400", "150"), selected = "400", multiple = FALSE,
                                             selectize = TRUE, width = NULL, size = NULL)),
                          column(3,
                                 selectInput("pathway_addInteractor1", "Max Number of Interactors to Show (1st shell)", choices=c("5", "10", "20", "50"), selected = "10", multiple = FALSE,
                                             selectize = TRUE, width = NULL, size = NULL)),
                          column(3, 
                                 selectInput("pathway_addInteractor2", "Max Number of Interactors to Show (2nd shell)", choices=c("0", "5", "10", "20", "50"), selected = "0", multiple = FALSE,
                                             selectize = TRUE, width = NULL, size = NULL))
                        ),
                        
                        actionButton("pathway_string_update","Submit"),
                        tags$hr(),
                        
                        tags$div(id = "pathway_string_result",
                          uiOutput("input_gene_title"),      
                          tags$div(id="pathway_string_gene_table",
                                   dataTableOutput("pathway_string_gene_table")),
                          tags$div(id="pathway_string_svg", 
                                   uiOutput("pathway_svg")
                                   ),
                          tags$div(id="pathway_network_table", class="collapse",
                                   dataTableOutput("pathway_string_network_table"))
                        ),
                        tags$div(id="pathway_string_enrichment_results",
                                 tags$div(id="pathway_string_analysis_tables",
                                          uiOutput("pathway_string_func_dts")))
               )
              
             )))}
