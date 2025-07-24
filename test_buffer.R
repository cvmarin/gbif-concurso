#test gbif con buffer
setwd("C:/R/concurso_gbif2025")
#library
library(sf)
library(rgbif)
library(ggplot2) #comprobar buffer

#datos

chillan <- st_read("poligono_chillangoogle.kml") #Leer kml

b_chillan <- chillan %>%  st_buffer(1000) #agregar buffer en metros
ggplot() +
  labs(x="Longitude (WGS84)", y="Latitude") +   
  geom_sf(data=b_chillan, col="red", lwd=0.4, pch=21)+
  geom_sf(data=chillan, col="blue", lwd=0.4, pch=21) 
wkt_chillanbuffer = st_as_text(st_geometry(b_chillan[1,])) #pasar a texto

wkt_chillanbuffer <-  wkt_chillanbuffer %>%
  wk::wkt() %>% 
  wk::wk_orient() #cambiar orientacion

test_chillanbuffer <- occ_download(pred_within(wkt_chillanbuffer ),format = 'SPECIES_LIST')
occ_download_wait(test_chillanbuffer)

listachillan_buffer <- occ_download_get('0001988-250717081556266') %>% #importar descarga
  occ_download_import()
