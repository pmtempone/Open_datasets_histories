---#librerias----

library(dplyr)


----#descarga----

url_filmacion <- "https://recursos-data.buenosaires.gob.ar/ckan2/set-filmaciones/BAset.csv"
  
download.file(url_filmacion,destfile = "BAset.csv")

BAset <- read.csv("~/Documentos/Open_datasets_histories/BAset.csv", sep=";", comment.char="#")

----#analisis----
  
summary(BAset)

#el barrio que menos pedidos tiene

sort(summary(BAset$BARRIO))
