library(ggfortify)
library(plotly)

df <- matrix_full_eco_elev_clim_sat
df <- na.omit(df)
df_continous <- df[,colnames(df) %in% c("temp","elevation","NDVI","precip")]
df_discrete <- df[,!(colnames(df) %in% c("temp","elevation","NDVI","precip"))]

df_continous <- apply(df_continous, 2, as.numeric)

pca <- princomp(df_continous, scores=T, cor=T)

scores <- pca$scores
x <- scores[,1]
y <- scores[,2]
z <- scores[,3]

loads <- pca$loadings

load_names <- rownames(loads)

scale.loads <- 5

#Plot de la PCA
library(plotly)
p <- plot_ly() %>%
  add_trace(x=x, y=y, z=z,
            type="scatter3d", mode="markers", color = df_discrete$sp)

for (k in 1:nrow(loads)) {
   x <- c(0, loads[k,1])*scale.loads
   y <- c(0, loads[k,2])*scale.loads
   z <- c(0, loads[k,3])*scale.loads
   p <- p %>% add_trace(x=x, y=y, z=z,
            type="scatter3d", mode="lines",
            line = list(width=8),
            opacity = 1,
            name = load_names[k])
}
print(p)
#notre PCA avec nos 4 variables (elevation, precip, temp et NDVI) en fonction de nos 2 espèces (enfin 3 car sous-espèce de renard...)