source(paste0(script.dirname,"/ui/GetUsageMaterialTabContent.R"))
source(paste0(script.dirname,"/ui/GetAboutMaterialTabContent.R"))
source(paste0(script.dirname,"/ui/GetAnalizeMaterialTabContent.R"))


ui <- fluidPage(theme=shinytheme("flatly"), 
   title = "T3LP: Statistical software analysis for GeneExpression",
   tags$style(type="text/css", "body {padding-top: 70px;}"),
   navbarPage(title = div("T3LP", img(src = "https://github.com/djangosee/TFGShinyApp/blob/UserInterface/www/logo.png?raw=true", height = "70px", 
              style = "position: fixed; right: 10px;  top: -5px;")),
              collapsible = T,
              position = "fixed-top",
    #tabPanel("Usage",GetMaterialUsageTabContent()),
    GetMaterialAnalizeTabContent
    #tabPanel("About",GetMaterialAboutTabContent())
  ))
  #Hauré de fer una funció apply per definir el entorn de les pagines
  #Inicialment només seria necesari fer 3 tabs
  ## About: Descripció del frontend, objectius i autor
  ## Parallax (para hacer bonito)
  ## .rmd
  ## Usage: Tutorial
  ## Pasos a seguir i protocol d'anàlisi
  ## .rmd
  ## Analisi: Resultats i obtenció del pdf.
  ## Load csv
  ## Plots, taules i cards
  ## Download pdf analisis
  ## input.Rnw (plantilla generica)

  

