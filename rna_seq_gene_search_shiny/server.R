library(shiny)
library(DT)
library(pool)
library(dplyr)
library(plotly)
library(png)
# library(shinyjs)
# library(shinyjqui)
library(XML)
library(htmltools)
# library(svglite)
library(RCurl)


source('helpFunctions.R')
source('boxplot_view.R')
source('barchart_view.R')
source('string_database_view.R')


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  updateSelectizeInput(session, "genes", choices = gene_table$gene_name, server = TRUE)
  updateSelectizeInput(session, "experiments", choices = c("All", experiment_table$description), server = TRUE)
  observeEvent(input$experiments, {
    
    updateSelectizeInput(session, "conditions",
                         choices = c("All", getConditionChoices(input$experiments)))
  })
  
  #click update button to get report
  observeEvent(input$update,{
    input_conditions<- getInputConditions(input$experiments, input$conditions)
    input_experiments <- getInputExperiments(input$experiments)$description

    expressions2 = getExpression2(input$genes, input_experiments, input_conditions)
    
    if (input$update[1]>1){
      removeUI(
        selector= '#report_tabs'
      )
    }

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
  
    #draw box plot
    output$gene_expression_boxplot<- renderPlotly({
      shiny::validate(
        need(expressions2, ("SELECT A GENE"))
      )

      #get experiment
      exp = expressions2$experiment
      exp_unique = sort(unique(exp))

      col_num = sapply(exp_unique, function(e){
        cons = expressions2$condition_name[expressions2$experiment==e]
        col = length(unique(cons))
        return(col)
      })
      widths = as.vector(col_num/sum(col_num))

      plots = lapply(exp_unique, function(e){
        plot_data = expressions2[expressions2$experiment==e,]
        p= plot_ly(plot_data, x = ~factor(condition_name), y = ~expression, name = e, type = "box", boxpoints="all", pointpos=0) %>%
          layout( margin=list(b=250), title=input$genes[1], xaxis=list(title=e, showgrid = FALSE), yaxis=list(showgrid=FALSE))
        return(p)
      })

      subplot(plots, shareY=T, widths=widths)
    })


    #draw bar chart
    output$gene_expression_barchart <- renderPlotly({
      shiny::validate(
        need(expressions2, ("SELECT A GENE"))
      )

      data = expressions2[,c("gene_name","condition_name", "experiment", "expression")]
      plotdata = aggregate(data$expression,
                           list(data$experiment,data$condition_name),
                           mean)

      var = aggregate(data$expression,
                      list(data$experiment,data$condition_name),
                      sd)
      plotdata$var = var$x
      colnames(plotdata) <- c("experiment", "condition", "expression","SD")

      exp = plotdata$experiment
      exp_unique = sort(unique(exp))


      col_num = sapply(exp_unique, function(e){
        cons = expressions2$condition_name[expressions2$experiment==e]
        col = length(unique(cons))
        return(col)
      })

      widths = as.vector(col_num/sum(col_num))

      plots = lapply(exp_unique, function(e){
        plot_data = plotdata[plotdata$experiment==e,]
        p= plot_ly(plot_data, x = ~factor(condition), y = ~expression, name = e, type = "bar", error_y = ~list(value = SD, color="black")) %>%
          layout(margin=list(b=250), title=input$genes[1], xaxis=list(title=e, showgrid = FALSE), yaxis=list(showgrid=FALSE, title="AVG"))
        return(p)
      })

      subplot(plots, shareY=T, widths=widths)
    })

    
    #init the string database tab
    input_genes = input$genes
    input_network_flavor = "actions"
    input_addInteractor1 = 10
    input_addInteractor2 = 0
    input_requried_score = 400
    
    #get string gene description
    output$string <- DT::renderDataTable({
      shiny::validate(
        need(input_genes[1]!="", ("SELECT A GENE"))
      )
      
      data = synchronise(getStringMap2(input_genes))
      data[1,]
    }, selection="none")
    
    svg =synchronise(getStringSVG2(input_genes, input_network_flavor,
                                   input_addInteractor1, input_addInteractor2,
                                   input_requried_score))
    
    output$svg <- renderUI({
      tags$div(id="string_svg_sub",
               HTML(svg)
      )
      
    })
    
    # Parse the file
    doc <- htmlParse(svg)
    
    # Extract genes in the svg
    p <- xpathSApply(doc, "//g/text", xmlValue)
    genes = unique(p)
    
    #get string gene interaction
    output$string_network_table <- renderDataTable({
      nets = synchronise(getStrNetwork2(genes, input_requried_score))
      nets = nets[,c("preferredName_A", "preferredName_B", "score")]
      names(nets) = c("Node A", "Node B", "Score")
      nets
    }, options=list(order=list(list(2,'desc'))), rownames = FALSE, selection="none")
    
    
    #get string functional enrichment results
    fun_enrich = synchronise(getFunctionalEnrichment2(genes))
    category = factor(fun_enrich$category)
    std_cate_name = c("Biological Process (GO)", "Molecular Function (GO)", "Cellular Component (GO)",
                      "KEGG Pathways", "PFAM Protein Domains", "INTERPRO Protein Domains and Features")
    names(std_cate_name) <- c("Process", "Function", 'Component',"KEGG", "Pfam", "InterPro")
    
    #generate multiple datatables based on pathway categories
    lapply(levels(category), function(c){
      output[[paste0('string_func_', c)]] <- DT::renderDataTable({
        fun_enrich[fun_enrich$category==c,]
      }, options=list(order=list(list(4,'asc'))), rownames = FALSE, selection="none")
    })
    
    #render data table for functional enrichment results
    output$string_func_dts <- renderUI({
      lapply(levels(category), function(c){
        tags$div(
          tags$br(),
          tags$h4(std_cate_name[[c]], style="background: lightgrey; color:black;"),
          DT::dataTableOutput(paste0('string_func_', c))
        )
      })
    })
    
    ############################
    #download expression responsive for the download button event
    output$download <- downloadHandler(
      filename= function(){
        paste0(input$genes,"_expression_", Sys.Date(), ".csv")
      },
      
      content = function(file){
        write.csv(expressions2, file)
      }
    )
  })
  
  #update report according to button event update, or update string database
  observeEvent(input$updateString, {
    input_genes = input$genes
    input_network_flavor = input$network_flavor
    input_addInteractor1 = input$addInteractor1
    input_addInteractor2 = input$addInteractor2
    input_requried_score = input$requried_score
  
    svg =synchronise(getStringSVG2(input_genes, input_network_flavor,
                                   input_addInteractor1, input_addInteractor2,
                                   input_requried_score))
    
    output$svg <- renderUI({
      tags$div(id="string_svg_sub",
               HTML(svg)
      )
      
    })
    
    # Parse the file
    doc <- htmlParse(svg)
    
    # Extract genes in the svg
    p <- xpathSApply(doc, "//g/text", xmlValue)
    genes = unique(p)
    
    #get string gene interaction
    output$string_network_table <- renderDataTable({
      nets = synchronise(getStrNetwork2(genes, input_requried_score))
      nets = nets[,c("preferredName_A", "preferredName_B", "score")]
      names(nets) = c("Node A", "Node B", "Score")
      nets
    }, options=list(order=list(list(2,'desc'))), rownames = FALSE, selection="none")
    
    
    #get string functional enrichment results
    fun_enrich = synchronise(getFunctionalEnrichment2(genes))
    category = factor(fun_enrich$category)
    std_cate_name = c("Biological Process (GO)", "Molecular Function (GO)", "Cellular Component (GO)",
                      "KEGG Pathways", "PFAM Protein Domains", "INTERPRO Protein Domains and Features")
    names(std_cate_name) <- c("Process", "Function", 'Component',"KEGG", "Pfam", "InterPro")
    
    #generate multiple datatables based on pathway categories
    lapply(levels(category), function(c){
      output[[paste0('string_func_', c)]] <- DT::renderDataTable({
        fun_enrich[fun_enrich$category==c,]
      }, options=list(order=list(list(4,'asc'))), rownames = FALSE, selection="none")
    })
    
    #render data table for functional enrichment results
    output$string_func_dts <- renderUI({
      lapply(levels(category), function(c){
        tags$div(
          tags$br(),
          tags$h4(std_cate_name[[c]], style="background: lightgrey; color:black;"),
          DT::dataTableOutput(paste0('string_func_', c))
        )
      })
    })
  })
  
  
  
})
