#Aixo es per treballar desde el Rstudio

#getwd()

#setwd("/home/toni/TFGShinyApp/")

#####

source("init.R",local = TRUE)
source("ui.R", local = TRUE)
source("server.R", local = TRUE)


shinyApp(ui = ui, server = server)




