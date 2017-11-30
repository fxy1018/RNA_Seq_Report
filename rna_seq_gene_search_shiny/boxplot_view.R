boxplot_view <-function() {
  
  tabPanel("Box Plot", 
           tags$div(id='boxplot_view',
                    tags$div(id='boxplot_content',
                             plotlyOutput("gene_expression_boxplot", height="200%")
                             )
                    )
           )

  }




