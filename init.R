#Arxiu per carregar tots els paquets

#Llistat de paquets
list.of.packages <- c("shiny","shinymaterial","stringi")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) suppressMessage(install.packages(new.packages))