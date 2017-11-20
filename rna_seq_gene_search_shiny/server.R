library(shiny)
library(DT)
library(pool)
library(dplyr)
library(plotly)
library(png)


source('helpFunctions.R')
source('boxplot_view.R')
source('barchart_view.R')
source('string_database_view.R')
source('plot_control_panel_view.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  updateSelectizeInput(session, "genes", choices = gene_table$gene_name, server = TRUE)
  updateSelectizeInput(session, "experiments", choices = c("All", experiment_table$description), server = TRUE)
  observeEvent(input$experiments, {

    updateSelectizeInput(session, "conditions",
                        choices = c("All", getConditionChoices(input$experiments)))
  })
  
  observeEvent(input$update, {
    input_conditions<- getInputConditions(input$experiments, input$conditions)
    print(input_conditions)
    expressions = getExpression(input$genes, input$experiments, input_conditions)
    print(head(expressions))
    if (input$update[1]<2){
      insertUI(
        selector = '#col_9_report',
        ui = tags$div(
          id = "report_tabs",
          navbarPage("Report", id = "overview",  theme = shinytheme("simplex"),
                     boxplot_view(),
                     barchart_view(),
                     string_database_view()
          )
        )
      )
      
      #insert ui for plot control
     
      insertUI(
        selector = '#plot_control_panel',
        ui = tags$div(
          htmlTemplate("www/plot_control.html"),
          plot_control_panel_view()
        )
      )
        
      
    }
    
    getTagList <- function(){
      
      out= lapply(1:length(input_conditions), function(i) {
        tags$li(class="list-group-item",input_conditions[i])
      })
      out
    }
    
    
    output$orderedCondition <- renderUI({
      out = list(tags$label("Condition Order", `for`="conditionOrder"), 
                 tags$div(id="conditionOrder",
                          tags$ul(id="sortable",
                                  class="list-group",
                                  getTagList())),
                 tags$script('
                   $( function() {
                     $( "#sortable" ).sortable();
                     $( "#sortable" ).disableSelection();
                   } );
                   
                 '))
      
      out
      
    })
    
    output$gene_expression_boxplot<- renderPlotly({
      x_layout <- list(title="")
      boxplot = plot_ly(expressions, x=~ensembl_id, y = ~expression, type="box",
                        color = ~factor(condition_id), boxpoints="all", pointpos=0) %>% layout(boxmode="group", xaxis=x_layout)
    })
    
 
    
    output$gene_expression_barchart <- renderPlotly({
      
      data = expressions[,c("ensembl_id","condition_id", "expression")]
      plotdata = aggregate(data$expression, 
                           list(data$ensembl_id,data$condition_id), 
                           mean)
      
      var = aggregate(data$expression, 
                      list(data$ensembl_id,data$condition_id), 
                      sd)
      plotdata$var = var$x
      colnames(plotdata) <- c("Gene", "Condition", "Expression","SD")

      barchart = plot_ly(data=plotdata, x=~Gene, y=~Expression,
                         type='bar', color = ~factor(Condition),
                         error_y = ~list(value = SD, color="black")) %>%
        layout(yaxis = list(title="AVG"), xaxis = list(title= ""))



      barchart
    })
    
    output$string <- DT::renderDataTable({
      data = getString(c("gene_test"))
      data
    })
  })
  observeEvent(input$updateColorControlPanel, {
    insertUI(
      selector = '#test_data_flow',
      ui = tags$div(
        tags$h1("hello from test data flow"),
        tags$h1(input$updateTitle)
        
      )
    )
  })
  
  

  
  
  
  
  
  
  
})

# getConditionChoices(condition_table)