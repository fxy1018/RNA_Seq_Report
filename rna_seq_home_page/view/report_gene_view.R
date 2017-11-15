report_gene_view <-function(conditionTable) {

  tabPanel("Gene",

     tabsetPanel(
       tabPanel("Gene expression",
                tags$h3("Choose conditions:"),
                fluidRow(
                  column(3, 
                         selectizeInput("gene_condition",
                                     "Conditions:",
                                     choices = c("All", conditionTable$name), 
                                     multiple = TRUE, 
                                     options = list(create = FALSE))),
                 
                  column(3, 
                         selectizeInput("gene_gene",
                                   "Genes: ",
                                   choices = NULL,
                                   multiple = TRUE,
                                   options = list(placeholder = "select a gene", maxOptions = 30)
                                   )),
                  column(3,
                         selectInput("gene_method",
                                     "Method: ",
                                     choices = c("TPM"),
                                     selected = "TPM",
                                     multiple = FALSE)),
                  column(3, 
                         selectInput("gene_ncbi_project",
                                     "Compare to NCBI Bioproject: ",
                                     choices = NULL,
                                     multiple= FALSE))
                ),
                
                fluidRow(
                  column(4,
                        offset = 6,
                        downloadButton("downloadGeneExpressionTable", 
                                      label="Download Gene Expression Table")),
                  column(2,
                         offset = 0,
                         actionButton("gene_update", label="Update"))
                  
                  
                ),
                
                tags$hr(),
                
                conditionalPanel(
                  condition = "input.gene_update > 0",
                  fluidRow(
                    tabsetPanel(type = "tabs",
                                tabPanel("Gene Expression Table", DT::dataTableOutput("gene_expression_table")),
                                tabPanel("Bar Chart",
                                         plotlyOutput("gene_expression_barchart"),
                                         tags$br(),
                                         plotlyOutput("ncbi_gene_expression_barchart")),
                                tabPanel("Box Plot", 
                                         plotlyOutput("gene_expression_boxplot"),
                                         tags$br(),
                                         plotlyOutput("ncbi_gene_expression_boxplot", height='200%'))
                    )
                  )
                )
       ),

       tabPanel("Pairwise Comparison",
                tags$h1("Comparison Gene Table"),
                tags$h3("Choose two conditions:"),
                fluidRow(
                  column(3,
                         selectInput("condition1",
                                     "Condition 1:",
                                     c("All",
                                       # unique(as.character(geneTable$comparison))
                                       conditionTable$name[-1]
                                     ),
                                     selected = "All")
                  ),

                  column(3,
                         selectInput("condition2",
                                     "Condition 2:",
                                     c("All",
                                       # unique(as.character(geneTable$comparison))
                                       conditionTable$name[-(length(conditionTable$name))]
                                     ),
                                     selected = "All")
                  ),

                  column(3,
                         numericInput("fdr",
                                      "FDR:",
                                      value = 0.05,
                                      min = 0.00,
                                      max = 1.00,
                                      step = 0.01)
                  ),
                  column(3,
                         selectInput("protein_type",
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
                  column(4,
                         offset = 6,
                         downloadButton("downloadDiffGeneTable", label="Download Gene Table")),
                  column(2,
                         offset = 0,
                         actionButton("gene_diff_update", label="Update"))
                ),
         
                tags$hr(),
                
                conditionalPanel(
                  condition = "input.gene_diff_update > 0",
                  fluidRow(
                    DT::dataTableOutput("diff_gene_table")
                  ),
                  
                  br(),
                  
                  fluidRow(
                    tags$h1("Volcano Plot"),
                    plotlyOutput("volcanoPlot")
                  )
                )
        )
    )
  )}




