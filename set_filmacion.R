---#librerias----

library(dplyr)
library(ggplot2)
library(ggmap)
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
barrio <- summary(BAset$BARRIO)
barrios <- data.frame(cant=summary(BAset$BARRIO),BARRIO=names(summary(BAset$BARRIO)))

qplot(summary(BAset$BARRIO),col=BAset$BARRIO,binwidth=15)

ggplot(data = barrios,aes(x=cant,col=BARRIO)) + geom_bar()

names(barrio)

----#plot map------ # Sun Dec 11 11:30:06 2016 ------------------------------
cantidades_barrio <- BAset %>% filter(!is.na(latlng)) %>%  
  mutate(cantidad=as.numeric(latlng)) %>%  
  group_by(LNG,LAT) %>%
  summarise(total.count=n(), 
            count=sum(is.na(cantidad)))


map <- get_map(location = 'Buenos Aires', zoom = 11)

mapPoints <- ggmap(map) + geom_point(aes(x = LNG, y = LAT, size = count,col=count), data = cantidades_barrio, alpha = .5)

mapPoints
