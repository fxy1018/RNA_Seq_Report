barchart_view <-function() {
  
  tabPanel("Bar Chart",
           plotlyOutput("gene_expression_barchart"),
           tags$br(),
           tags$h1("hello")
  )
  
}