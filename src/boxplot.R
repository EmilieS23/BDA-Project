# Factor Analysis
data_stat <- matrix_full_eco_elev_clim_sat

#Température et landcover
P_fact <- ggplot(data = data_stat, mapping = aes(x = Landcover, y = temp, fill = Landcover))

P_fact <- P_fact + geom_boxplot(varwidth = TRUE, outlier.shape = NA) +  # Change boxplot width 
  geom_jitter(alpha = 0.2, size = 2, width = 0.1) +  # Add points and spread them
  stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") +  # Add mean 
  theme_classic()

ploty <- ggplotly(P_fact)
print(ploty)
# Fit a linear model with landcover as a factor
linear_modelPfact <- lm(temp ~ Landcover, data = data_stat)
anova(linear_modelPfact)

em <- emmeans(linear_modelPfact, list(pairwise ~ Landcover), adjust = "tukey")
print(em)

#NDVI et landcover
P_fact2 <- ggplot(data = data_stat, mapping = aes(x = Landcover, y = NDVI, fill = Landcover))

P_fact2 <- P_fact2 + geom_boxplot(varwidth = TRUE, outlier.shape = NA) +  # Change boxplot width 
  geom_jitter(alpha = 0.2, size = 2, width = 0.1) +  # Add points and spread them
  stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") +  # Add mean 
  theme_classic()

ploty2 <- ggplotly(P_fact2)
print(ploty2)
# Fit a linear model with landcover as a factor
linear_modelPfact2 <- lm(temp ~ Landcover, data = data_stat)
anova(linear_modelPfact2)

em2 <- emmeans(linear_modelPfact2, list(pairwise ~ Landcover), adjust = "tukey")
print(em2)