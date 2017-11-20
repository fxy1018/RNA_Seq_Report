plot_control_panel_view <- function(){
  tags$div(class="collapse", id="collapseColorControlPanel",
           tags$form(style="background-color: lightblue",
             tags$div(class="form-group",
                      textInput("plotTitle", "Title", 
                                placeholder="Title of Plot")),
             
             tags$div(class="form-group",
                      textInput("plotXTitle", "X-axis Title", 
                                placeholder="X-axis Title of Plot")),
             
             tags$div(class="form-group",
                      textInput("plotYTitle", "Y-axis Title", 
                                placeholder="Y-axis Title of Plot")),
             
             tags$div(class="form-group",
                      tags$label("Color", `for`="plotColor"),
                      tags$input(type="color",
                                 class="form-control",
                                 id="plotColor",
                                 placeholder="colors")),
             tags$div(class="form-group",
                      tags$div(id="orderCondition",
                               uiOutput("orderedCondition"))
                      )
             ),
           
            actionButton("updateColorControlPanel", label='update plots')
           )
  
  
}