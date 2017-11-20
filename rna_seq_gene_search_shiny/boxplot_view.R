boxplot_view <-function() {
  
  tabPanel("Box Plot",
           plotlyOutput("gene_expression_boxplot"),
           tags$br(),
           tags$h1("hello")
           )

  }




