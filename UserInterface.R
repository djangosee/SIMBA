library("shiny")
#devtools::install_github("ericrayanderson/shinymaterial")
library("shinymaterial")
library("stringi")

themecolor <- "teal"
ui <- material_page(
    title = tags$a(tags$img(src='https://github.com/djangosee/TFGShinyApp/blob/UserInterface/www/logo.png?raw=true',height=70,width=70)),
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
      material_tabs(
        tabs = c("About"="About","Usage"="Usage","Analysis"="Analysis"),
        color = themecolor
      ),
#GetUsageMaterialTabContent()
      material_tab_content(
      tab_id = "Usage",
      div(class="toc-wrapper pinned hide-on-small-only", id="Usage",
          tags$ul(class="section table-of-contents",
                  tags$li(tags$a(href="#Introduction","Introduction")),
                  tags$li(tags$a(href="#Load_file","Load file")),
                  tags$li(tags$a(href="#Analysis","Analysis")),
                  tags$li(tags$a(href="#Download report","Download report")),
                  tags$li(tags$a(href="#New session","New session"))
                  )),
      div(class="row",div(class="col s12 m9 offset-m2 truncate",
          #GetUIintroduction()
          #GetUIload_file()
          #GetUIanalysis()
          #GetUIdownloadreport()
          #GetUINewsession()
          div(id="Introduction",
              class="section scrollpsy",
              tags$h3("Introduction"),
              style="display:inline-block;width:100px;white-space: initial;",
              p(stri_rand_lipsum(1, start_lipsum = F))),
          div(id="Load_file",
                  class="section scrollpsy",
                  tags$h3("Load File"),
                  p(stri_rand_lipsum(1, start_lipsum = TRUE)))
          
          ))),
#GetMaterialAboutTabContent()
    material_tab_content(
      tab_id = "About",
      tags$h1("Tutorial: T3LP shiny app")
    ),
#GetMaterialUsageTabContent()
    material_tab_content(
      tab_id = "Analysis",
      tags$h1("Analisis de microarrays")
    )
    
  )
  
server <- function(input, output) {
    
}

shinyApp(ui = ui, server = server)




