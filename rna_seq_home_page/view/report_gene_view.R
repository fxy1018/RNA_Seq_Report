report_gene_view <-function(conditionTable) {

  tabPanel("Gene",

     tabsetPanel(
       tabPanel("Gene expression",
                tags$h3("Choose conditions:"),
                fluidRow(
                  column(6, 
                         selectizeInput("gene_condition",
                                     "Conditions:",
                                     choices = c("All", conditionTable$name), 
                                     multiple = TRUE, 
                                     options = list(create = FALSE))),
                 
                  column(6, 
                         selectizeInput("gene_gene",
                                   "Genes: ",
                                   choices = NULL,
                                   multiple = TRUE,
                                   options = list(placeholder = "select a gene", maxOptions = 10)
                                   ))
                ),
                
                fluidRow(
                  column(2,
                         offset = 10,
                         actionButton("gene_update", label="Update"))
                ),
                
                tags$hr(),
                
                fluidRow(
                  DT::dataTableOutput("gene_expression_table")
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
                         checkboxInput("screted", "Only Show Screted Proteins", value = FALSE, width = "400px")
                  )

                ),
                
                fluidRow(
                     downloadButton("downloadDiffGeneTable", label="Download Gene Table")
                ),
                
                tags$hr(),
                
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


  )}




