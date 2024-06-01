###My species: Vulpes vulpes (sp1) & Microtus arvalis (sp2)
###Analyse relation proie-prédateur
########################################################################################################
#Library les plus couramment utiliser dans le projet

library(rgbif) 
library(rnaturalearth)
library(ggplot2)
library(rinat)
library(raster)
library(sf)
library(elevatr)

###Codes pour arriver à la matrice full (matrix_full_eco_elev_clim_sat) avec toutes les données qui nous intéressent 
###pour les plots et analyse statistique

source('src/import_data.R')

source('src/ecosystems.R')

source('src/elevation.R')

source('src/clim_data.R')

source('src/NDVI.R')

###Map 

source('src/3d_map_points.R')

###Statistiques
library(ggcorrplot)
library(ggfortify)
library(corrplot)
library(pheatmap)
library(randomcoloR)
library(emmeans)
library(plotly)
library(dplyr)
library(ggridges)
library(fmsb)

source('src/Heatmap.R')

source('src/ML.R')

source('src/boxplot.R')

source('src/Aggregate.R')

source('src/pca.R')

source('src/ggplot.R')
