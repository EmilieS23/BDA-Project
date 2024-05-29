library(geodata)
###################################################################
###################################################################


# Assuming matrix_full is your data frame with latitude and longitude columns
spatial_points <- SpatialPoints(coords = matrix_full_eco_elev[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))
#attention ! toujours dans l'ordre longitude et ensuite latitude !!!!

###################################################################
###################################################################
# Retrieve temperature data for Switzerland

#avec boucle for pour faire tous les mois de l'années

sw_clim <- worldclim_country("switzerland", var = "tmin", path = tempdir())
sw_clim_br <- brick(sw_clim)

matrix_clim = NULL
vec_colnames = NULL

for (i in 1:12)
{
  raster_month <- sw_clim_br[[i]]
  vec_colnames <- c(vec_colnames,names(raster_month))

  temps <- extract(raster_month, spatial_points, method = 'bilinear')


  matrix_clim <- cbind(matrix_clim,temps)
}

colnames(matrix_clim) <- vec_colnames

#january_raster <- sw_clim$CHE_wc2.1_30s_tmin_1

# Extract temperature values at species occurrences
#temp<- raster::extract(january_raster, spatial_points, method = 'bilinear')
temp<- raster::extract(matrix_clim, spatial_points, method = 'bilinear')

temp <- data.frame(temp)

# Plot density of temperature data for species occurrences
ggplot(temp, aes(x = temp)) +
  geom_density(color = "darkblue", fill = "lightblue", adjust = 3) +
  theme_bw()


###################################################################
###################################################################
###################################################################
###################################################################
# Retrieve precipitation data for Switzerland
sw_clim_pec <- worldclim_country("switzerland", var = "prec", path = tempdir())
sw_clim_pec <- brick(sw_clim_pec)

matrix_pec = NULL
vec2_colnames = NULL

for (i in 1:12)
{
  raster_month2 <- sw_clim_pec[[i]]
  vec2_colnames <- c(vec2_colnames,names(raster_month2))

  precip <- extract(raster_month2, spatial_points, method = 'bilinear')


  matrix_pec <- cbind(matrix_pec,precip)
}

colnames(matrix_pec) <- vec2_colnames

#january_raster <- sw_clim_pec$CHE_wc2.1_30s_prec_1

# Extract precipitation values at Marmota marmota occurrences
precip <- raster::extract(matrix_pec, spatial_points, method = 'bilinear')

precip <- data.frame(precip)

# Plot density of precipitation data for Marmota marmota occurrences
ggplot(precip, aes(x = precip)) +
  geom_density(color = "black", fill = "darkgreen", adjust = 2) +
  theme_bw()



#################
matrix_full_eco_elev_clim <- data.frame(matrix_full_eco_elev,precip,temp)


# Load required library
# Load required library
library(ggplot2)

# Create the ggplot
pretemp <- ggplot(matrix_full_eco_elev_clim, aes(x = precip,y=temp, color = sp)) + # nolint
  geom_point() +
  theme_minimal()


print(pretemp)
#test --> ici calcule des températures moyennes pour chacune des mes espèces

#m <- tapply(matrix_full_eco_elev_clim$temp, matrix_full_eco_elev_clim$sp, mean)
#print(m)