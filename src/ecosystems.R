# Load the raster package
library(raster)
library(ggplot2)

# Set the file path to your GeoTIFF
file_path <- "C:/Users/schra/Bureau/Université/Master Biologie/BDA/Projet/data/WorldEcosystem.tif" 

# Read the raster GeoTIFF
ecosystem_raster <- raster(file_path)


Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )
## crop and mask
r2 <- crop(ecosystem_raster, extent(Switzerland))
ecosystem_switzerland <- mask(r2, Switzerland)
plot(ecosystem_switzerland)

# Assuming matrix_full is your data frame with latitude and longitude columns
spatial_points <- SpatialPoints(coords = matrix_full[, c("longitudesp","latitudesp")], proj4string = CRS("+proj=longlat +datum=WGS84"))

plot(spatial_points,add=T,pch=16,cex=2) #CA NE MARCHE PAS

# Extract values
eco_values <- raster::extract(ecosystem_switzerland, spatial_points)

# Print the extracted values
#View(eco_values)



######### metadata: 



matrix_full$eco_values <- eco_values

metadat_eco <- read.delim("C:/Users/schra/Bureau/Université/Master Biologie/BDA/Projet/data/WorldEcosystem.metadata.tsv")

# combinaison des eco data avec ma prédécente matrix_full pour avoir une nouvelle matrix_full plus complète !
matrix_full_eco <- merge(matrix_full, metadat_eco, by.x = "eco_values", by.y = "Value", all.x = TRUE)


p1 <- ggplot(matrix_full_eco, aes(x = Climate_Re, fill = sp)) +
    geom_bar(position = "dodge") +
    labs(title = "Count of observation of each species by climate", x = "climate", y ="count of observation") +
    theme_minimal()


print(p1)
