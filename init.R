#Arxiu per carregar tots els paquets

#Llistat de paquets
#source("https://bioconductor.org/biocLite.R")
#biocLite("genefilter")
list.of.packages <- c("RColorBrewer","shinycssloaders","shinyjs","ggplot2","heatmaply","gplots","Biobase","RCurl","genefilter","shinythemes","DT","tools","readxl","shiny","shinymaterial","stringi")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages())]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE, quietly = T)
