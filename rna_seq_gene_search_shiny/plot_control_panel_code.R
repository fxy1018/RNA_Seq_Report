###edit plot code####
# source('plot_control_panel_view.R')
# #insert ui for plot control
# 
# insertUI(
#   selector = '#plot_control_panel',
#   ui = tags$div(
#     htmlTemplate("www/plot_control.html"),
#     plot_control_panel_view()
#   )
# )


# getDragList <- function(){
#   
#   out= lapply(1:length(input_experiments), function(i) {
#     orderInput(paste0("drag_exp_", input_experiments[i]), input_experiments[i], items = input_experiments, width="200px",style="border-bottom-style: ridge")
#   })
#   out
# }


# output$orderedCondition <- renderUI({
#   out = list(tags$label("Condition Order", `for`="conditionOrder"), 
#              tags$div(id="conditionOrder", style="border-style: ridge",
#                       getDragList())
#              )
#   out
# })
# 
# 
# output$plotColor <- renderUI({
#   out=list(tags$label("Color",`for`="plotColor"),
#            tags$div(id="plotColor",
#                     tags$ul(id="colorList",
#                             class="list-group",
#                             getColorList())))
# 
#            
# })
# 
# 
# getColorList<-function(){
#   out = lapply(1:length(input_experiments), function(i){
#     tags$li(class="list-group-item", 
#             tags$span(colourInput(paste0("col_", input_experiments[i]), input_experiments[i], "white")))
#   })
#   
#   
# }
# 

# observeEvent(input$updateColorControlPanel, {
#   removeUI(
#     selector='#barchart_content'
#   )
#   
#   removeUI(
#     selector='#boxplot_content'
#   )
#   
#   output$update_gene_expression_barchart <- renderPlotly({
#     input_conditions<- getInputConditions(input$experiments, input$conditions)
#     input_experiments <- getInputExperiments(input$experiments)$description
#     
#     expressions2 = getExpression2(input$genes, input_experiments, input_conditions)
#     
#     shiny::validate(
#       need(expressions2, ("SELECT A GENE"))
#     )
#     
#     
#     data = expressions2[,c("gene_name","condition_name", "experiment", "expression")]
#     plotdata = aggregate(data$expression, 
#                          list(data$experiment,data$condition_name), 
#                          mean)
#     
#     var = aggregate(data$expression, 
#                     list(data$experiment,data$condition_name), 
#                     sd)
#     plotdata$var = var$x
#     colnames(plotdata) <- c("experiment", "condition", "expression","SD")
#     
#     exp = plotdata$experiment
#     exp_unique = sort(unique(exp))
#     
#     
#     col_num = sapply(exp_unique, function(e){
#       cons = expressions2$condition_name[expressions2$experiment==e]
#       col = length(unique(cons))
#       return(col)
#     })
#     
#     widths = as.vector(col_num/sum(col_num))
#     
#     if (input$plotTitle == ""){
#       title = input$genes[1]
#     }else{
#       title = input$plotTitle
#     }
#     
#     plots = lapply(exp_unique, function(e){
#       plot_data = plotdata[plotdata$experiment==e,]
#       p= plot_ly(plot_data, x = ~factor(condition), y = ~expression, name = e, type = "bar", error_y = ~list(value = SD, color="black")) %>%
#         layout(margin=list(b=250), title=title, xaxis=list(title=e, showgrid = FALSE), yaxis=list(showgrid=FALSE, title="AVG"))
#       return(p)
#     })
#     
#     subplot(plots, shareY=T, widths=widths)
#   })
#   
#   
#   insertUI(
#     selector = '#barchart_view',
#     ui = tags$div(id='barchart_content',
#                   plotlyOutput("update_gene_expression_barchart", height="200%"),
#       tags$h1(input$plotTitle)
#       
#     )
#   )
#   
#   insertUI(
#     selector = '#boxplot_view',
#     ui = tags$div(id="boxplot_content",
#       tags$h1("hello from test boxplot"),
#       tags$h1(input$plotTitle)
#       
#     )
#   )
#   
# })

