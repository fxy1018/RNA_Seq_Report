string_database_view <-function() {
  
  tabPanel("String Database",
           # plotlyOutput("gene_expression_barchart"),
           # tags$br(),
           
           DT::dataTableOutput("string"),
           tags$h1("hello")
  )
  
}