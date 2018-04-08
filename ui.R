source("./ui/GetUsageMaterialTabContent.R")
source("./ui/GetAboutMaterialTabContent.R")
source("./ui/GetAnalizeMaterialTabContent.R")

themecolor <- "teal"

ui <- material_page(
  
  title = tags$a(tags$img(src='https://github.com/djangosee/TFGShinyApp/blob/UserInterface/www/logo.png?raw=true',height=70,width=70)),
  nav_bar_fixed = T,
  nav_bar_color = themecolor,
  background_color = "#c8e6c9",
  material_tabs(
    tabs = c("Usage"="Usage","Analize"="Analize","About"="About"),
    color = themecolor
  ),
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
  GetMaterialUsageTabContent(),
  GetMaterialAboutTabContent(),
  GetMaterialAnalizeTabContent()
  
)
