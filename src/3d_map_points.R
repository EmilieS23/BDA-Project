library(sf)
library(elevatr)
library(raster)

sf_use_s2(FALSE)

Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )
elevation_switzerland <- get_elev_raster(Switzerland, z = 8)
plot(elevation_switzerland)

## crop and mask
r2 <- crop(elevation_switzerland, extent(Switzerland))
elevation_switzerland <- mask(r2, Switzerland)
plot(elevation_switzerland)

library(rayshader)
###### 3d plot v1 

elmat <- raster_to_matrix(elevation_switzerland)

attr(elmat, "extent") <- extent(elevation_switzerland)

elmat %>% 
  sphere_shade(texture = "bw") %>%
  plot_map()

############################################
###########################################


  ###### 3d version 
elmat %>% 
  sphere_shade(texture = "bw") %>%
plot_3d(elmat, zscale = 150, fov = 0, theta = 135, zoom = 0.75, 
        phi = 45, windowsize = c(1500, 800))


################## add texture  
library(png)

elevation.texture.map <- readPNG("C:/Users/schra/Bureau/Université/Master Biologie/BDA/Projet/data/Switzerland.png")
#elevation.texture.map.crop <- crop.image(elevation.texture.map,xleft=146,ybottom=7,xright=203,ytop=256)

##############################
############################### add points 


latitude <- matrix_full_eco_elev_clim$latitudesp
longitude <- matrix_full_eco_elev_clim$longitudesp

# Create a data frame for GBIF data
gbif_coord <- data.frame(longitude,latitude)

# Extract elevation values at Marmota marmota occurrences
ll_prj <- "EPSG:4326" 
points <- sp::SpatialPoints(gbif_coord, 
                            proj4string = sp::CRS(SRS_string = ll_prj))
elevation_points <- extract(elevation_switzerland, points, method='bilinear')
elevation_df <- data.frame(elevation = elevation_points)


  ###### 3d version 
elmat %>% 
  sphere_shade(texture = "bw") %>%
  add_overlay(elevation.texture.map, alphacolor = NULL, alphalayer = 0.7)  %>%
   add_shadow(cloud_shade(elmat, zscale = 100, start_altitude = 500, end_altitude = 2000,), 0) %>%
   add_water(detect_water(elmat), color = "lightblue") %>%
plot_3d(elmat, zscale = 100, fov = 0, theta = 135, zoom = 0.75, 
        phi = 45, windowsize = c(1500, 800))


mycolor <- rep("black",nrow(matrix_full_eco_elev_clim_sat))
mycolor[matrix_full_eco_elev_clim_sat$sp == "Vulpes vulpes"]<-"orange"
mycolor[matrix_full_eco_elev_clim_sat$sp == "Microtus arvalis"]<-"grey"

# Render points on the 3D elevation map
render_points(
  extent = extent(Switzerland), size = 10,
  lat = gbif_coord$latitude, long = gbif_coord$longitude,
  altitude = elevation_points + 100, zscale = 150, color = "mycolor"
)

library(sf)
library(elevatr)
library(raster)
library(tidyverse)
library(RColorBrewer)
library(rayshader)
library(eks)


sf_use_s2(FALSE)



 sf_points <- data.frame(
    lat = matrix_full_eco_elev_clim$latitudesp,
    lon = matrix_full_eco_elev_clim$longitudesp
  ) |>
    st_as_sf(coords = c("lon", "lat"), crs = 4326)
plot(sf_points)

skde1 <- st_kde(sf_points, gridsize = c(100, 100))
plot(skde1)
dataxx = st_get_contour(skde1, cont = c(seq(1, 99, 5)), disjoint = FALSE)



# Create a function to generate the color palette
color_palette <- colorRampPalette(c("darkolivegreen4","darkolivegreen3","darkseagreen1","yellow","orange","red","darkred"))



# Define the number of colors in the palette
num_colors <- 20  # Adjust as needed

# Generate the color palette
palette <- color_palette(num_colors)



elmat <- raster_to_matrix(elevation_switzerland)

elmat %>%
 sphere_shade(texture = "bw") %>%
 add_overlay(elevation.texture.map, alphacolor = NULL, alphalayer = 0.9)  %>%
 add_overlay(generate_polygon_overlay(dataxx, 
                        palette = palette, linewidth=0,
                        extent = extent(elevation_switzerland), heightmap = elmat),
                        alphalayer=0.7)  %>%
plot_3d(elmat, zscale = 150, fov = 0, theta = 135, zoom = 0.75, 
        phi = 45, windowsize = c(1500, 800))

# Render points on the 3D elevation map
render_points(
  extent = extent(Switzerland), size = 5,
  lat = gbif_coord$latitude, long = gbif_coord$longitude,
  altitude = elevation_points + 100, zscale = 150, color = "black"
)

elmat <- raster_to_matrix(elevation_switzerland)

elmat %>%
 sphere_shade(texture = "bw") %>%
 add_overlay(elevation.texture.map, alphacolor = NULL, alphalayer = 0.9)  %>%
 add_overlay(generate_polygon_overlay(dataxx, 
                        palette = palette, linewidth=0,
                        extent = extent(elevation_switzerland), heightmap = elmat),
                        alphalayer=0.7)  %>%
add_overlay(generate_point_overlay(sf_points, color="black", size=5,
attr(elevation_switzerland,"extent"), heightmap = elmat)) %>%

plot_map()
