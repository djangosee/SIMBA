#Aixo es per treballar desde el Rstudio

#getwd()

#setwd("/home/toni/TFGShinyApp/")

#####

source("init.R")
source("ui.R")
source("server.R")


shinyApp(ui = ui, server = server)




