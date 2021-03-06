source(paste0(script.dirname,"/ui/Analize/GetUIAnalysisLoadFile.R"))

GetMaterialAnalizeTabContent <- tabPanel("Analize", GetAnalysisAnalizeSidebar,
    #Carreguem el sidebar del load file                 
    conditionalPanel("input.Start>0",mainPanel("",
              p(HTML(paste("<b>","Gene Expression Matrix (gene x samples: first 6 rows and 6 columns):","</b>"))),
              checkboxInput("checkbox", label = "View all Data", value = F),
              withSpinner(tableOutput("tableHead"),color="#0b295b"),
              p(HTML(paste("<b>","F-test: Multiple comparision analysis","</b>"))),
              withSpinner(DT::dataTableOutput("tableMCA"),color="#0b295b"),
              br(),
              fluidRow(
                actionButton("show1", "Theory of ANOVA",icon=icon("glyphicon glyphicon-info-sign",lib = "glyphicon")),
                actionButton("show2", "Theory of FDR",icon=icon("glyphicon glyphicon-info-sign",lib = "glyphicon")),
                actionButton("showi2", "Interpretation Hint",icon=icon("glyphicon glyphicon-question-sign",lib = "glyphicon"),style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
              ),
              hr(),
              p(HTML(paste("<b>","Tukey: Post-hoc","</b>"))),
              withSpinner(DT::dataTableOutput("tableTukey"),color="#0b295b"),
              br(),
              fluidRow(
              actionButton("show3", "Theory of Tukey",icon=icon("glyphicon glyphicon-info-sign",lib = "glyphicon")),
              actionButton("showi3", "Interpretation Hint",icon=icon("glyphicon glyphicon-question-sign",lib = "glyphicon"),style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
              # p(HTML(paste("<b>","Tukey: Post-hoc plot","</b>"))),
              # withSpinner(plotOutput("tukeyplot",height = 800,width="auto")),
              hr(),
              p(HTML(paste("<b>","PCA: principal components analysis (Visual analysis)","</b>"))),
              withSpinner(plotOutput("pca"),color="#0b295b"),
              fluidRow(
              actionButton("show4", "Theory of PCA",icon=icon("glyphicon glyphicon-info-sign",lib = "glyphicon")),
              actionButton("showi4","Interpretation Hint",icon=icon("glyphicon glyphicon-question-sign",lib = "glyphicon"),style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
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
              mainPanel(withSpinner(plotOutput("lineplot",height = 800, width = 800),color="#0b295b"),
                        actionButton("showi5", "Interpretation Hint",icon=icon("glyphicon glyphicon-question-sign",lib = "glyphicon"),style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
              p(HTML(paste("<b>","HeatMap: Graphic Representation"),"</b>")),
              withSpinner(plotlyOutput("heatmap",height = "850px"),color="#0b295b"),
              fluidRow(
                actionButton("show6", "Theory of HeatMap",icon=icon("glyphicon glyphicon-info-sign",lib = "glyphicon")),
                actionButton("showi6", "Interpretation Hint",icon=icon("glyphicon glyphicon-question-sign",lib = "glyphicon"),style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
              value=2)
              ))

