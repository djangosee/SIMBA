
GetAnalysisLoadFile <- sidebarPanel("",
          p("STEP1. Load the file (ExpressionGeneData)"),
          fileInput('file1',"Select main file:",accept=c(".xlsx",".csv"),buttonLabel = "Load File"),
          tags$a(href='www/jeju.csv',"Example file", download = "example.csv"),
          hr(),
          p("STEP2. Select factors to get the analysis in the main panel (ExpressionData Analysis)."),
          uiOutput("factorSelection"),
          uiOutput("covariableSelection"),
          sliderInput("alpha","Significance Levels (alpha):",value=0.1,min=0.05,max=0.2,step=0.05),
          conditionalPanel("input.tabselected==2",
                           actionButton("button","Render HeatMap")
                           )
        )
GetAnalysisExpressionSet <- tabPanel("ExpressionData Analysis",
                                     p("Gene Expression Matrix (gene x samples):"),
                                     tableOutput("tableHead"),
                                     p("F-test: Multiple comparision analysis"),
                                     tableOutput("tableMCA"),
                                     p("HeatMap: Graphic Representation"),
                                     withSpinner(plotlyOutput("heatmap",height = "850px")),
                                     value=2)
  



