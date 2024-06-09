df <- matrix_full_eco_elev_clim_sat
df <- na.omit(df)

df_continous <- df[, colnames(df) %in% c("temp", "elevation", "NDVI", "precip")]
df_discrete <- df[, !(colnames(df) %in% c("temp", "elevation", "NDVI", "precip"))]

#Modèle linéaires

data_stat <- df_continous

#LM pluie+température
P <- ggplot(data = data_stat, mapping = aes(x = temp, y = precip))
P + geom_point(shape = 18) + 
  geom_smooth(method = "lm", se = FALSE) + 
  theme_classic()


linear_model <- lm(temp ~ precip, data = data_stat)
summary(linear_model)
#p-value = 0.1408, donc n'est pas significative, pas de corrélation entre pluie et température 

#LM NDVI+elevation
P2 <- ggplot(data = data_stat, mapping = aes(x = NDVI, y = elevation))
P2 + geom_point(shape = 18) + 
  geom_smooth(method = "lm", se = FALSE) + 
  theme_classic()


linear_model2 <- lm(NDVI ~ elevation, data = data_stat)
summary(linear_model2)
#p-value de <2e-16 donc trps significative, très forte corrélation entre le NDVI et l'élévation

#LM température+elevation
P3 <- ggplot(data = data_stat, mapping = aes(x = temp, y = elevation))
P3 + geom_point(shape = 18) + 
  geom_smooth(method = "lm", se = FALSE) + 
  theme_classic()


linear_model3 <- lm(temp ~ elevation, data = data_stat)
summary(linear_model3)
#comme avant, p-value de <2e-16 donc très forte corrélation entre température et élévation

#LM précipitation+elevation
P4 <- ggplot(data = data_stat, mapping = aes(x = precip, y = elevation))
P4 + geom_point(shape = 18) + 
  geom_smooth(method = "lm", se = FALSE) + 
  theme_classic()


linear_model4 <- lm(precip ~ elevation, data = data_stat)
summary(linear_model4)
#p-value de 0.00121 donc corrélation significative entre les précipitation et l'élevation

print("Model temp~precip : p-value = 0.1408
Model NDVI~elevation : p-value <2e-16
Model temp~elevation : p-value <2e-16
Model precip~elevation : p-value = 0.00121")
