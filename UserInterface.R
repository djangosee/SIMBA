#library("shiny")
#devtools::install_github("ericrayanderson/shinymaterial")
#library("shinymaterial")
#getwd()

themecolor <- "teal"
ui <- material_page(
    title = "T3LP",
    nav_bar_fixed = T,
    nav_bar_color = themecolor,
    background_color = "#c8e6c9",
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
    material_parallax(
      image_source = "./www/3D6.jpg"
    ),
      material_tabs(
        tabs = c("About"="About.Tab"),
        color = themecolor
      ),
      material_tab_content(
      tab_id = "About.Tab"
      )
    
  )
  
server <- function(input, output) {
    
}

shinyApp(ui = ui, server = server)




