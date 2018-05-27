
GetAnalysisDataVisualitzationSidebar<- sidebarPanel("",
          p("STEP1. Load the file (ExpressionGeneData)"),
          fileInput('file1',"Select main file:",accept=c(".xlsx",".csv"),buttonLabel = "Load File"),
          p("Example file (TFGShinyApp/www/example.csv)"),
          hr(),
          uiOutput("NAs")
          )
          
GetAnalysisAnalizeSidebar <- sidebarPanel("",
          p("STEP2. Setting and configuration."),
          uiOutput("factorSelection"),
          uiOutput("covariableSelection"),
          uiOutput("TissueSelection"),
          uiOutput("TissueCategory"),
          sliderInput("alpha","Significance Levels (alpha):",value=0.1,min=0.05,max=0.2,step=0.05),
          sliderInput("NAInput","Percentage of missing values to remove by treatment.",value=0.5,min=0,max=0.95,step=0.05),
          actionButton("Start", "Start Analysis")
           )


  



