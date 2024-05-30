#Species and data with gbif --> 2 species

sp1 <- c("Vulpes vulpes") #renard roux
sp2 <- c("Microtus arvalis") #campagnol commun

gbif_data_sp1 <- occ_data(scientificName = sp1, hasCoordinate = TRUE, limit = 5000)
gbif_data_sp2 <- occ_data(scientificName = sp2, hasCoordinate = TRUE, limit = 5000)

occur <- gbif_data_sp1$data
gbif_data_sp1CH <- occur[occur$country == "Switzerland",]
occur <- gbif_data_sp2$data
gbif_data_sp2CH <- occur[occur$country == "Switzerland",]

Switzerland <- ne_countries(scale = "medium", returnclass = "sf", country = "Switzerland")

# Extract relevant data from GBIF occurrences for sp1

sp <- gbif_data_sp1CH$species
latitudesp <- gbif_data_sp1CH$decimalLatitude
longitudesp <- gbif_data_sp1CH$decimalLongitude
sourcesp <- rep("gbif", length(sp1))

data_gbif_sp1 <- data.frame(sp, latitudesp, longitudesp, sourcesp)

# Extract relevant data from GBIF occurrences for sp2

sp <- gbif_data_sp2CH$species
latitudesp <- gbif_data_sp2CH$decimalLatitude
longitudesp <- gbif_data_sp2CH$decimalLongitude
sourcesp <- rep("gbif", length(sp2))

data_gbif_sp2 <- data.frame(sp, latitudesp, longitudesp, sourcesp)

#donc ici j'ai mes données gbif latitudes/longitudes des mes 2 espèces en Suisse 

#Species and data with inat 

sp1_inat <- get_inat_obs(query = "Vulpes vulpes", place_id = "switzerland")
sp2_inat <- get_inat_obs(query = "Microtus arvalis", place_id = "switzerland")

sp <- sp1_inat$scientific_name
latitudesp <- sp1_inat$latitude
longitudesp <- sp1_inat$longitude
sourcesp <- rep("inat", length(sp1))

datasp1_inat <- data.frame(sp, latitudesp, longitudesp, sourcesp)

sp <- sp2_inat$scientific_name
latitudesp <- sp2_inat$latitude
longitudesp <- sp2_inat$longitude
sourcesp <- rep("inat", length(sp2))

datasp2_inat <- data.frame(sp, latitudesp, longitudesp, sourcesp)

#Comme avant, latitude et longitude de inat pour mes 2 espèces

# Combine GBIF and iNaturalist data frames
matrix_full <- rbind(datasp1_inat, data_gbif_sp1,datasp2_inat, data_gbif_sp2)

# Plot combined data on a map of Switzerland
sp_plot <- ggplot(data = Switzerland) +
  geom_sf() +
  geom_point(data = matrix_full, aes(x = longitudesp, y = latitudesp, fill = sourcesp), size = 4, 
             shape = 23) + theme_classic()

print(sp_plot)
#matrix_full qui représente mes données avec mes deux espèces, en Suisse
