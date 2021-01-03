#' ---
#' title: "Calcular parámetros hidrográficos"
#' author: "Edel Tejada"
#' date: "21 de noviembre, 2020"
#' output: github_document
#' 
#' ---

## Proceso 0
library(rgrass7)
library(sf)
library(raster)
library(sp)

## Primera Ejecucion (Diretorio de la region)
gisdbase <- 'grass-data-test' #Base de datos de GRASS GIS
wd <- getwd() #Directorio de trabajo
wd

## Segundo (definir la localizacion)

loc <- initGRASS(gisBase = "/usr/lib/grass78/",
                 home = wd,
                 gisDbase = paste(wd, gisdbase, sep = '/'),
                 location = 'rdom',
                 mapset = "PERMANENT",
                 override = TRUE)

## Septimo (informacion)

execGRASS(
  'g.list',
  flags = 't',
  parameters = list(
    type = c('raster', 'vector')
  )
)



## Octavo (Paquete SP para representar como un Raster de R)

use_sp()
dem_sp <- readRAST('dem')

## Noveno (Guardar parametros gaficos y plotear dem)
op <- par()
plot(dem_sp)

######################################################

c_ozama <- readVECT('ozama_basin')
plot (c_ozama)

###################   
plot(dem_sp)
plot(c_ozama, add=T, col='transparent', border='white', lwd=3);par(op[c('mfrow','mar')])

## Codigos de analis 

dem_r0 <- raster(dem_sp)
dem_r0


dem_r1 <- crop(dem_r0, c_ozama)
dem_r1
plot(dem_r1)

dem_ozama <- mask(dem_r1, c_ozama)
plot(dem_ozama)
dem_ozama

summary(dem_ozama)
mean(dem_ozama[],na.rm=T)
hist(dem_ozama)

pend_ozama <- terrain(x = dem_ozama, opt = 'slope', unit = 'degrees')
plot(pend_ozama)
pend_ozama

summary(pend_ozama)
mean(pend_ozama[],na.rm=T)
hist(pend_ozama)

c_ozama
library(rgeos)
gArea(c_ozama)
OBJETOSF <- st_as_sf(c_ozama)
st_area(OBJETOSF)

library(lwgeom)
st_perimeter(OBJETOSF)

