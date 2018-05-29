source(paste0(script.dirname,"/ui/Analize/GetUIAnalysisLoadFile.R"))

GetMaterialAnalizeTabContent <- tabPanel("Analize", GetAnalysisAnalizeSidebar,
    #Carreguem el sidebar del load file                 
    conditionalPanel("input.Start>0",mainPanel("",
              p(HTML(paste("<b>","Gene Expression Matrix (gene x samples: first 6 rows and 6 columns):","</b>"))),
              tableOutput("tableHead"),
              p(HTML(paste("<b>","F-test: Multiple comparision analysis","</b>"))),
              tableOutput("tableMCA"),
              hr(),
              p(HTML(paste("<b>","Tukey: Post-hoc","</b>"))),
              tableOutput("tableTukey"),
              hr(),
              p(HTML(paste("<b>","PCA: principal components analysis (Visual analysis)","</b>"))),
              plotOutput("pca"),
              hr(),
              p(HTML(paste("<b>","LinePlot: Mean gene expression by covariable","</b>"))),
              radioButtons("orderLine", label = h5("Order By (decreasing):"),
                           choices = list("Treatment" = 1, "Functions" = 2, "Both"= 3), 
                           selected = 1),
              conditionalPanel("input.orderLine!=2",uiOutput('treatSelector')),
              radioButtons("defCol", label = h5("ColourPicker"),
                           choices = list("Default colors" = 1, "Customize colors" = 2), 
                           selected = 1),
              sidebarPanel(
              conditionalPanel("input.defCol==2",uiOutput('colorSelector'))),
              mainPanel(plotOutput("lineplot",height = 800, width = 800)),
              p(HTML(paste("<b>","HeatMap: Graphic Representation"),"</b>")),
              plotlyOutput("heatmap",height = "850px"),
              value=2)
              ))

