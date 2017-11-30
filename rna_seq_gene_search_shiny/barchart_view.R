barchart_view <-function() {
  
  tabPanel("Bar Chart",
           tags$div(id='barchart_view',
                    tags$div(id='barchart_content',
                             plotlyOutput("gene_expression_barchart")
                    )
           )
  )
  
}