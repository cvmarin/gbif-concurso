#Script selección de datos con rgbif
#Catalina Marín
#2025


#settings

#library
library(sf)
library(rgbif)
library(rgdal)
library(maptools)

#Datos----

sal <- readOGR("salmuera.kml")


coord <- getKMLcoordinates(sal, ignoreAltitude = T)

sal_tabla <- as.data.frame(sal@coords)

sal_tabla$poly1 <- paste(sal_tabla$coords.x2, sal_tabla$coords.x1, sep = " ")

poligonos <- st_as_sf(sal_tabla, coords = c("coords.x1", "coords.x2"))

test_poli <- as.character(poligonos$geometry)

large_wkt <- sf::st_read("poligono.shx") %>% sf::st_geometry() %>% sf::st_as_text()


test_1 <- occ_download(pred_within(large_wkt),format = "SIMPLE_CSV")

large_wkt <- large_wkt %>%
  wk::wkt() %>% 
  wk::wk_orient()

occ_download_wait(test_1)

registros <- occ_download_get(test_1) %>% #obtenerlas occurrencias
  occ_download_import()



chillan <- readOGR("poligono_chillangoogle.kml")


tkml <- getKMLcoordinates(kmlfile="poligono_chillangoogle.kml", ignoreAltitude=T)
#make polygon
p1 = Polygon(tkml)
#make Polygon class
p2 = Polygons(list(p1), ID = "drivetime")
p3= SpatialPolygons(list(p2),proj4string=CRS("+init=epsg:4326"))

#CHILLAN

chillan <- st_read("poligono_chillangoogle.kml") #Leer kml
chillan <- st_geometry(chillan) #cambiar a geometria
chillan_noa <- st_zm(chillan) #quitar altitud
wkt_chillan = st_as_text(st_geometry(chillan_noa[1,])) #pasar a texto

wkt_chillan <- wkt_chillan  %>%
  wk::wkt() %>% 
  wk::wk_orient() #cambiar orientacion

test_chillan <- occ_download(pred_within(wkt_chillan ),format = 'SPECIES_LIST')
occ_download_wait(test_chillan)

registros <- occ_download_get(test_chillan) %>% #obtenerlas occurrencias
  occ_download_import()

#agregar buffer a poligono
p = st_polygon(chillan$geometry)

#convertir puntos en poligono

sal_puntos <- sal@coords
sal_poligono <- st_polygon(sal)
sa_buffer <- st_buffer(sal_puntos, .4)
