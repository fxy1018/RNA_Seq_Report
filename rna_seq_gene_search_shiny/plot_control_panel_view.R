plot_control_panel_view <- function(){
  tags$div(class="collapse", id="collapseColorControlPanel",
           tags$form(style="background-color: white",
             tags$div(class="form-group",
                      textInput("plotTitle", "Title", 
                                placeholder="Title of Plot")),
             tags$div(class="form-group",
                      textInput("plotYTitle", "Y-axis Title", 
                                placeholder="Y-axis Title of Plot")),
             
             tags$div(class="form-group",
                      tags$div(id="plotColor",
                               uiOutput("plotColor"))
             ),
             tags$div(class="form-group",
                      tags$div(id="orderCondition",
                               uiOutput("orderedCondition"))
                      )
             ),
            checkboxInput("sepBarchart", "multiple barchart", value = FALSE, width = NULL),
            checkboxInput("sepBoxplot", "multiple barchart", value = FALSE, width = NULL),
           
            actionButton("updateColorControlPanel", label='update plots', icon=icon("hand-pointer-o"))
           )
  
  
}