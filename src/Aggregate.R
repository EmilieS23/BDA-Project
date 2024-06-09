data_stat <- matrix_full_eco_elev_clim_sat

#Aggrégation des data
aggregated_data <- aggregate(
  cbind(elevation, precip, temp, NDVI) ~ W_Ecosystm, 
  data = data_stat, 
  FUN = mean
)

data_stat_discrete <- data_stat[c("sp", "W_Ecosystm")]
aggregated_data_final_species <- merge(aggregated_data, data_stat_discrete, by = "W_Ecosystm")
aggregated_data_final_species <- aggregated_data_final_species %>% distinct()

#Température des 3 espèces
temperature <- ggplot(matrix_full_eco_elev_clim_sat, aes(x = temp, y = sp, fill = sp)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

print(temperature)

#Précipitation des 3 espèces
pluie <- ggplot(matrix_full_eco_elev_clim_sat, aes(x = precip, y = sp, fill = sp)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

print(pluie)

#NDVI des 3 espèces
n <- ggplot(matrix_full_eco_elev_clim_sat, aes(x = NDVI, y = sp, fill = sp)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

print(n)

#Elevation des 3 espèces
e <- ggplot(matrix_full_eco_elev_clim_sat, aes(x = elevation, y = sp, fill = sp)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

print(e)

##Radarchart

data_stat <- matrix_full_eco_elev_clim_sat

# Agréger les données par W_Ecosystm
aggregated_data_species <- aggregate(
  cbind(elevation, precip, temp, NDVI) ~ sp, 
  data = data_stat, 
  FUN = mean
)

min1 <- c(0,0,-10,0)
max2 <- c(apply(aggregated_data_species[,2:5],2,max))
sp1 <- aggregated_data_species[1,2:5]
sp2 <- aggregated_data_species[2,2:5]
row_id <- c(1,2,aggregated_data_species$sp)
 
aggregated_data_species <- rbind(min1,max2,sp1,sp2)
row.names(aggregated_data_species) <- row_id

radarchart(aggregated_data_species)


#le graphe montre une supeposition des espèces, donc vivent dans les mêmes millieux
#montre bien une superposition de niche, ce à quoi on peut s'attendre si nous avons proir-prédateur
