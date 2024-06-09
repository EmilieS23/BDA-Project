df <- matrix_full_eco_elev_clim_sat
df <- na.omit(df)

df_continous <- df[, colnames(df) %in% c("temp", "elevation", "NDVI", "precip")]
df_discrete <- df[, !(colnames(df) %in% c("temp", "elevation", "NDVI", "precip"))]

data <- df_continous

## Heatmap - voir correclation entre les variables et avec les différents landcover
my_group <- df_discrete[c("Landcover")]
row.names(my_group) <- c(1:nrow(my_group))

hm <- pheatmap(scale(data),
         annotation_row = my_group)
print(hm)
