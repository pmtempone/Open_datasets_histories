---#librerias----

library(dplyr)


----#descarga----

url_filmacion <- "https://recursos-data.buenosaires.gob.ar/ckan2/set-filmaciones/BAset.csv"
  
download.file(url_filmacion,destfile = "BAset.csv")

BAset <- read.csv("BAset.csv", sep=";", comment.char="#")
BAset$latlng <- paste(BAset$LAT,BAset$LNG)
----#analisis----
  
summary(BAset)

#el barrio que menos pedidos tiene

sort(summary(BAset$BARRIO))

cantidades <- BAset %>% filter(!is.na(latlng)) %>%  
  mutate(cantidad=as.numeric(latlng)) %>%  
  group_by(paste(CALLE,ALTURA)) %>%
  summarise(total.count=n(), 
            count=sum(is.na(cantidad)))

BAset[BAset$CALLE=="PLAZA" & BAset$ALTURA==3569,"RAZON_SOCIAL"]

