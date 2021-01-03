#' Borra máscara de GRASS GIS si la hubiere. Requiere una sesión de GRASS iniciada
hay_mascara <- function(){
  foo <- capture.output(
    execGRASS(
      'g.list',
      flags = 't',
      parameters = list(
        type = c('raster', 'vector')
      )
    )
  )
  bar <- any(grepl('mask', foo, ignore.case = T))
  return(bar)
}
if(hay_mascara()) execGRASS("r.mask", flags = c('r','quiet'))