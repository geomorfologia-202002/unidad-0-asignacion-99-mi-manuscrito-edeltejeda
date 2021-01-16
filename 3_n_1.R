# Inicio código de R:
devtools::source_url('https://raw.githubusercontent.com/biogeografia-master/scripts-de-analisis-BCI/master/biodata/funciones.R')

jpeg('mi_panel_de_tres_graficos.jpg', width = 1080, height = 500, res = 175)

crear_panel('Productos Generados/Cuenca_p_forma1.jpeg', 'Productos Generados/Histograma-de-elevaciones.png', 'Productos Generados/slope.jpeg') 
dev.off()

# Fin código de R:

