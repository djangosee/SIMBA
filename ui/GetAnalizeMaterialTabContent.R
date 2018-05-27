source(paste0(script.dirname,"/ui/Analize/GetUIAnalysisLoadFile.R"))

GetMaterialAnalizeTabContent <- tabPanel("Analize", GetAnalysisAnalizeSidebar,
    #Carreguem el sidebar del load file                 
    conditionalPanel("input.Start>0",mainPanel("",
              p("Gene Expression Matrix (gene x samples):"),
              tableOutput("tableHead"),
              p("F-test: Multiple comparision analysis"),
              tableOutput("tableMCA"),
              hr(),
              p("Tukey: Post-hoc"),
              tableOutput("tableTukey"),
              hr(), 
              p("LinePlot: Mean gene expression by covariable"),
              radioButtons("orderLine", label = h5("Order By (decreasing):"),
                           choices = list("Treatment" = 1, "Functions" = 2, "Both"= 3), 
                           selected = 1),
              conditionalPanel("input.orderLine!=2",uiOutput('treatSelector')),
              radioButtons("defCol", label = h5("ColourPicker"),
                           choices = list("Default colors" = 1, "Customize colors" = 2), 
                           selected = 1),
              sidebarPanel(
              conditionalPanel("input.defCol==2",uiOutput('colorSelector'))),
              mainPanel(plotOutput("lineplot",height = 500, width = 500)),
              p("HeatMap: Graphic Representation"),
              plotlyOutput("heatmap",height = "850px"),
              value=2)
              ))

