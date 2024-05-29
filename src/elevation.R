
################################################################################
################################################################################

library(sf)
library(elevatr)
library(raster)
library(rayshader)

sf_use_s2(FALSE)

Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )
elevation_switzerland <- get_elev_raster(Switzerland, z = 8)
#plot(elevation_switzerland)

spatial_points <- SpatialPoints(coords = matrix_full_eco[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))

# Extract values
elevation <- raster::extract(elevation_switzerland, spatial_points)


###################
#################
matrix_full_eco_elev <- data.frame(matrix_full_eco,elevation)


# Load required library
# Load required library
library(ggplot2)

# Create the ggplot
elev_plot <- ggplot(matrix_full_eco_elev, aes(x = elevation, fill = sp)) +
  geom_density(alpha = 0.5,adjust=3) +
  labs(title = "Density of Elevation by Climate",
       x = "Elevation", y = "Density") +
  theme_minimal()
print(elev_plot)