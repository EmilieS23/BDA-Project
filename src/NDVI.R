library(rgeoboundaries)
library(sf)
library(raster)
library(here)
library(ggplot2)
library(viridis)


# Downloading the boundary of switzerland
map_boundary <- geoboundaries("switzerland")

# Reading in the downloaded NDVI raster data
NDVI_raster <- raster("C:/Users/schra/Bureau/Université/Master Biologie/BDA/Projet/data/MYD13Q1_NDVI_2020_153.tif")

# Transforming the data
NDVI_raster <- projectRaster(NDVI_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
plot(NDVI_raster)

# Cropping the data
windows()
map_boundary <- geoboundaries("switzerland")
NDVI_raster <- raster::mask(NDVI_raster, as_Spatial(map_boundary))
plot(NDVI_raster)

# Dividing values by 10000 to have NDVI values between -1 and 1
gain(NDVI_raster) <- 0.0001

# Assuming matrix_full is your data frame with latitude and longitude columns
spatial_points <- SpatialPoints(coords = matrix_full_eco_elev_clim[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))
plot(spatial_points,add=T)


# Extract values
NDVI <- raster::extract(NDVI_raster, spatial_points)

matrix_full_eco_elev_clim_sat <- data.frame(matrix_full_eco_elev_clim,NDVI )
