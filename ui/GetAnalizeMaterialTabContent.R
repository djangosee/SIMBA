source(paste0(script.dirname,"/ui/Analize/GetUIAnalysisLoadFile.R"))

GetMaterialAnalizeTabContent <- tabPanel("Analize", 
    GetAnalysisLoadFile, #Carreguem el sidebar del load file                 
    mainPanel("",
              tabsetPanel(id="tabselected",
                tabPanel("Data Visualization",value=1,
                         tableOutput('table')),
                GetAnalysisExpressionSet,
                tabPanel("Report File",value=3)
                )
              )
)



