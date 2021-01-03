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
library(mapview)

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

## Tercero (Ruta del Dem en objeto)

dem <- 'data/dem.tif'

## Cuarto (Definir Proyecccion y Extencion de la Region con el Dem)
execGRASS(
  cmd = 'g.proj',
  flags = c('t','c'),
  georef=dem)
gmeta()

## Quinto (Importa dem a Grass y su extension)
execGRASS(
  cmd = 'r.in.gdal',
  flags=c('overwrite','quiet'),
  parameters=list(
    input=dem,
    output='dem'
  )
)

## Extension
demext <- 'data/dem-extension.geojson'
execGRASS(
  cmd = 'v.in.ogr',
  flags=c('overwrite','quiet'),
  parameters=list(
    input=demext,
    output='dem_extent'
  )
)



## Sexto (Actualizar la region)

execGRASS(
  cmd = 'g.region',
  parameters=list(
    raster = 'dem',
    align = 'dem'
  )
)


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

ruta_cuenca_ozama <- 'data/cuenca_ozama_indrhi.geojson'
c_ozama <- st_read(ruta_cuenca_ozama)
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
hist(dem_ozama)

pend_ozama <- terrain(x = dem_ozama, opt = 'slope', unit = 'degrees')
plot(pend_ozama)
pend_ozama

summary(pend_ozama)
hist(pend_ozama)

############################################

writeVECT(as_Spatial(c_ozama), 'c_ozama', v.in.ogr_flags='quiet')
execGRASS(
  "g.region",
  parameters=list(
    vector = "c_ozama"
  )
)
execGRASS(
  "r.mask",
  flags = c('verbose','overwrite','quiet'),
  parameters = list(
    vector = 'c_ozama'
  )
)
execGRASS(
  cmd = 'r.slope.aspect',
  flags = c('overwrite','quiet'),
  parameters = list(
    elevation='dem',
    slope='slope',
    aspect='aspect',
    pcurvature='pcurv',
    tcurvature='tcurv')
)

execGRASS(
  'g.list',
  flags = 't',
  parameters = list(
    type = c('raster', 'vector')
  )
)



pend_ozama_g <- readRAST('slope')

plot(pend_ozama_g);par(op[c('mfrow','mar')])
summary(pend_ozama_g)
summary(pend_ozama)
#########################
execGRASS(
  "g.region",
  parameters=list(
    raster = "dem"
  )
)


execGRASS(
  "r.mask",
  flags = c('r','quiet')
)

unlink_.gislock()
source('borrar_mascara_si_la_hubiere.R')

########## Reabrir base de datos de grass
plot(pend_ozama)

c_ozama_4326 <- st_transform(c_ozama, 4326)
mapa_c_ozama_4326 <- mapview(c_ozama_4326,map.types = 'OpenStreetMap', col.regions = 'blue', legend = FALSE)
mapa_c_ozama_4326 %>% mapview::mapshot(file = 'ozama_indrhi_4326_salida1.png')


