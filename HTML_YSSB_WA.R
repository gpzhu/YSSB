library(tmap)
library(tmaptools)
library(rgdal)
library(sf)
library(raster)
library(OpenStreetMap)
library(leaflet)
library(rgdal)
library(geodata)


setwd("D:\\YSSB\\MS_devlp\\Pred")
pred<-raster("GlobalPred2.tif")



setwd("C:\\Users\\ThinkPad\\Desktop\\WSU")
source("Extract by mask.R")

US <- getData('GADM', country='US', level=2)  
WA<-subset(US, NAME_1=="Washington")

WA1<-rasterize(WA,pred)
ext<-extractByMask(pred, WA1, spatial=T)
pred<-trim(ext) 

###########################################################################
###########################################################################
#pred<-aggregate(pred, fact=2)


pal = colorNumeric(c("#7f007f", "#0000ff",  "#007fff", "#00ffff", "#00bf00", "#7fdf00",
                     "#ffff00", "#ff7f00", "#ff3f00", "#ff0000", "#bf0000"), values(pred),  na.color = "transparent")
###Practice
leaflet() %>% 
  addTiles() %>%
  addRasterImage(x = pred , 
                 colors = pal, 
                 opacity = 1) %>%
  addLegend(pal = pal, values = values(pred), title = "Suitability")


##Go get the interactive map
US <- getData('GADM', country='US', level=2)  

WA<-subset(US, NAME_1=="Washington")


ggg<-leaflet() %>% addTiles() %>% 
  addRasterImage(x = pred, colors = pal, opacity = 1) %>%
  addLegend(pal = pal, values = values(pred), title = "Suitability")%>%
  #addPolygons(data=df, weight = 1, fillOpacity = 0) %>%
  addPolygons(data=WA, weight = 2, fillOpacity = 0,color = "black",dashArray = "3")

ggg


setwd("D:\\YSSB\\MS_devlp\\Pred")
library(htmlwidgets)
saveWidget(ggg, file = "YSSB_BioClim_WA.html")












