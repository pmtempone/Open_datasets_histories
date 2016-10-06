----#librerias----

library(rvest)
library(XML)
library(ggplot2)
library(plotly)
library(gridExtra)
---#extract data----
url <- "https://www.datazar.com/file/f5ef7d679-be2a-48c0-988a-279a1a42c7ee"

hurricanes <- url %>%
  html() %>%
  html_nodes(xpath='//*[@id="fileInfoContent"]/table[2]') %>%
  html_table()

hurricanes_df <- hurricanes[[1]]
colnames(hurricanes_df) = hurricanes_df[1, ] # the first row will be the header
hurricanes_df = hurricanes_df[-1, ]  
colnames(hurricanes_df)[5] <- "Damage (millions USD)"

summary(as.data.frame(hurricanes_df))
class(hurricanes_df)

hurricanes_df$`Damage (millions USD)` <- gsub(">|+","",hurricanes_df$`Damage (millions USD)`)
hurricanes_df$`Damage (millions USD)` <- gsub("[+]","",hurricanes_df$`Damage (millions USD)`)
hurricanes_df$`Damage (millions USD)` <- as.numeric(hurricanes_df$`Damage (millions USD)`)
hurricanes_df$Storms <- as.numeric(hurricanes_df$Storms)
hurricanes_df$Hurricanes <- as.numeric(hurricanes_df$Hurricanes)
hurricanes_df$Deaths <- as.numeric(hurricanes_df$Deaths)


----#graphics-----

g <- ggplot(data=hurricanes_df,mapping = aes(x=Year, y=`Damage (millions USD)`,group=1))+geom_line(colour="blue")+labs(title = "Damage in Millions USD")+theme(axis.title.x=element_blank(),
                                                                                                                        axis.text.x=element_blank(),
                                                                                                                        axis.ticks.x=element_blank())
g2 <- ggplot(data=hurricanes_df,mapping = aes(x=Year, y=Storms,group=1))+geom_line(colour="grey")+geom_smooth(method = "lm")+labs(title = "Storms")+theme(axis.title.x=element_blank(),
                                                                                                                                   axis.text.x=element_blank(),
                                                                                                                                   axis.ticks.x=element_blank())
g3 <- ggplot(data=hurricanes_df,mapping = aes(x=Year, y=Hurricanes,group=1))+geom_line(colour="red")+labs(title = "Hurricanes")+theme(axis.title.x=element_blank(),
                                                                                                           axis.text.x=element_blank(),
                                                                                                           axis.ticks.x=element_blank())
g4 <- ggplot(data=hurricanes_df,mapping = aes(x=Year, y=Deaths,group=1))+geom_line(colour="green")+labs(title = "Deaths")+theme(axis.title.x=element_blank(),
                                                                                                         axis.text.x=element_blank(),
                                                                                                         axis.ticks.x=element_blank())
----#share----

py <- ggplotly(username="pmtempone", key="bzomdw6f6i")  # open plotly connection

plotly_POST(ggplotly(g), filename = "Hurricanes: Damage in Millions USD")

ggplotly(g)
ggplotly(g2)
ggplotly(g3)
ggplotly(g4)


subplot(ggplotly(g,title()),ggplotly(g2),ggplotly(g3),ggplotly(g4),nrows = 2)
---