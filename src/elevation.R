library(rayshader)

sf_use_s2(FALSE)

Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )
elevation_switzerland <- get_elev_raster(Switzerland, z = 8)

spatial_points <- SpatialPoints(coords = matrix_full_eco[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))

elevation <- raster::extract(elevation_switzerland, spatial_points)

matrix_full_eco_elev <- data.frame(matrix_full_eco,elevation)

elev_plot <- ggplot(matrix_full_eco_elev, aes(x = elevation, fill = sp)) +
  geom_density(alpha = 0.5,adjust=3) +
  labs(title = "Density of Elevation by Climate",
       x = "Elevation", y = "Density") +
  theme_minimal()
print(elev_plot)

#rajout de l'atitude dans notre matrice originel
#présence de nos espèces en basses-moyenens altitudes
