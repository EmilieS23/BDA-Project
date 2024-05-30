library(rgeoboundaries)
library(here)
library(viridis)

map_boundary <- geoboundaries("switzerland")

#NDVI raster - NDVI est ce qui représente la productivité de la végétation
NDVI_raster <- raster("C:/Users/schra/Bureau/Université/Master Biologie/BDA/Projet/data/MYD13Q1_NDVI_2020_153.tif")

NDVI_raster <- projectRaster(NDVI_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

map_boundary <- geoboundaries("switzerland")
NDVI_raster <- raster::mask(NDVI_raster, as_Spatial(map_boundary))
plot(NDVI_raster)

# Dividing values by 10000 to have NDVI values between -1 and 1
gain(NDVI_raster) <- 0.0001

spatial_points <- SpatialPoints(coords = matrix_full_eco_elev_clim[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))
plot(spatial_points,add=T)

NDVI <- raster::extract(NDVI_raster, spatial_points)

matrix_full_eco_elev_clim_sat <- data.frame(matrix_full_eco_elev_clim,NDVI )
#Nous permets de voir que nos espèces se trouvent dans des zones productives, donc avec de la végétation
