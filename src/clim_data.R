library(geodata)
library(ggplot2)
library(sp)
library(raster)

spatial_points <- SpatialPoints(coords = matrix_full_eco_elev[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))

#Température moyenne sur une année (°C)
sw_clim <- worldclim_country("switzerland", var = "tavg", path = tempdir()) 
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

temp<- raster::extract(raster_month, spatial_points, method = 'bilinear')

temp <- data.frame(temp)

#Plot density of average temperature data for species occurrences
t <- ggplot(temp, aes(x = temp)) +
  geom_density(color = "red", fill = "orange", adjust = 3) +
  theme_bw()
print(t)

#Précipitation sur une année (mm)
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

precip <- raster::extract(raster_month2, spatial_points, method = 'bilinear')

precip <- data.frame(precip)

# Plot density of precipitation data for species occurrences
p <- ggplot(precip, aes(x = precip)) +
  geom_density(color = "darkblue", fill = "blue", adjust = 2) +
  theme_bw()

print(p)
#je n'utlisise que la température (moyenne) et les précipitations car les autres données ne me semblent pas pertinentes pour mes espèces
#c'est-à-dire vent, radiation solaire, etc. 

matrix_full_eco_elev_clim <- data.frame(matrix_full_eco_elev,precip,temp)

pretemp <- ggplot(matrix_full_eco_elev_clim, aes(x = precip,y=temp, color = sp)) + # nolint
  geom_point() +
  theme_minimal()

print(pretemp)
