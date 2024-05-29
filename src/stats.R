install.packages("ggcorrplot")
install.packages("corrplot")
install.packages("pheatmap")
install.packages("ggfortify")

# Load necessary libraries
library(ggplot2)
library(ggcorrplot)
library(ggfortify)
library(corrplot)
library(pheatmap)

####################################################################################
####################################################################################
####################################################################################
################## Data Exploration 

# Load and clean the dataset
df <- matrix_full_eco_elev_clim_sat
df <- na.omit(df)  # Remove rows with missing values = retirer les NA

# Separate continuous and discrete variables
df_continous <- df[, colnames(df) %in% c("temp", "elevation", "NDVI", "precip")]
df_discrete <- df[, !(colnames(df) %in% c("temp", "elevation", "NDVI", "precip"))]

####################################################################################
####################################################################################
##### Correlation Matrix and Corplot

# Compute the correlation matrix for continuous variables
mydata.cor <- cor(df_continous)

# Plot the correlation matrix with hierarchical clustering
my_corplot <- corrplot(mydata.cor, order = 'hclust', addrect = 3)
#1 correlation de 100% (-1 corrélation négative)

####################################################################################
####################################################################################
####################################################################################
####################################################################################
##### Annotated Heatmap 

### Simple heat map using only numeric values 

# Prepare data for heatmap
data <- df_continous
row.names(data) <- c(1:nrow(data))

# Generate a basic heatmap
heatmap(scale(data))
#organise nos échantilles (observation) par similarité, ici plot direct sans analyse
### Advanced heat map with annotation 

## Factor for annotation
my_group <- df_discrete[c("Landcover")]  # Only use "Landcover" for annotation
row.names(my_group) <- c(1:nrow(my_group))

# Generate an advanced heatmap with annotations
pheatmap(scale(data),
         annotation_row = my_group)
#permet de voir des grosses matrice de données
#### Customize the heatmap
library(randomcoloR)

# Define custom colors for the heatmap
data_col <- grDevices::colorRampPalette(c("black", "darkgreen", "white", "darkred"))

# Display the customized heatmap in a new window

ht <- pheatmap(scale(data),
         annotation_row = my_group,
         cutree_rows = 2,
         cutree_cols = 2,
         cellwidth = 100,
         cellheight = 0.2,
         color = data_col(10))
ht


####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
#### Basic Statistics 

#### Correlation between continuous variables 

# Prepare data for statistical analysis
data_stat <- df_continous

# Create a scatter plot with a linear regression line
P <- ggplot(data = data_stat, mapping = aes(x = temp, y = precip))
P + geom_point(shape = 18) + 
  geom_smooth(method = "lm", se = FALSE) + 
  theme_classic()


# Perform Pearson correlation test
cor.test(data_stat$temp, data_stat$precip)
#p-value = 0.7918 donc non significatif

# Fit a linear model
linear_model <- lm(temp ~ precip, data = data_stat)
summary(linear_model)
anova(linear_model)


####################################################################################
####################################################################################
####################################################################################
####################################################################################
#### Factor Analysis

# Load necessary library
library(emmeans)

# Use the original dataset for factor analysis
data_stat <- matrix_full_eco_elev_clim_sat

# Create a boxplot for temperature by landcover type
P_fact <- ggplot(data = data_stat, mapping = aes(x = Landcover, y = temp, fill = Landcover))

P_fact <- P_fact + geom_boxplot(varwidth = TRUE, outlier.shape = NA) +  # Change boxplot width 
  geom_jitter(alpha = 0.2, size = 2, width = 0.1) +  # Add points and spread them
  stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") +  # Add mean 
  theme_classic()

print(P_fact)

library(plotly)
ggplotly(P_fact)
# Fit a linear model with landcover as a factor
linear_model <- lm(temp ~ Landcover, data = data_stat)

####################################################################################
### Post-hoc test

# Perform ANOVA on the linear model
anova(linear_model)

# Conduct post-hoc tests with Tukey adjustment
em <- emmeans(linear_model, list(pairwise ~ Landcover), adjust = "tukey")
print(em)

####################################################################################
####################################################################################
####################################################################################
####################################################################################
######### Data Aggregation and Formatting for Plots

# Use the original dataset for data aggregation
data_stat <- matrix_full_eco_elev_clim_sat

# Aggregate data by W_Ecosystm
aggregated_data <- aggregate(
  cbind(elevation, precip, temp, NDVI) ~ W_Ecosystm, 
  data = data_stat, 
  FUN = mean
)

# Print the aggregated data
print(aggregated_data)

############## Add factor value: 

# Extract species and W_Ecosystm columns
data_stat_discrete <- data_stat[c("sp", "W_Ecosystm")]

# Merge aggregated data with discrete data by W_Ecosystm
aggregated_data_final_species <- merge(aggregated_data, data_stat_discrete, by = "W_Ecosystm")

# Load dplyr for data manipulation
library(dplyr)

# Ensure unique rows in the final aggregated data
aggregated_data_final_species <- aggregated_data_final_species %>% distinct()

####################################################################################
####################################################################################

####################################################################################


#### exercices 

## Beginner 
# link1 : https://r-graph-gallery.com/294-basic-ridgeline-plot.html

# library
library(ggridges)
library(ggplot2)
# Diamonds dataset is provided by R natively
#head(diamonds)
 
# basic example
ggplot(matrix_full_eco_elev_clim_sat, aes(x = temp, y = sp, fill = sp)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")


ggplot(matrix_full_eco_elev_clim_sat, aes(x = precip, y = sp, fill = sp)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")


##Advanced

# link1 : https://r-graph-gallery.com/143-spider-chart-with-saveral-individuals.html
# Library
library(fmsb)


data_stat <- matrix_full_eco_elev_clim_sat

# Agréger les données par W_Ecosystm
aggregated_data_species <- aggregate(
  cbind(elevation, precip, temp, NDVI) ~ sp, 
  data = data_stat, 
  FUN = mean
)

# Afficher les résultats
print(aggregated_data_species)

min1 <- c(0,0,-10,0)
max2 <- c(apply(aggregated_data_species[,2:5],2,max))
sp1 <- aggregated_data_species[1,2:5]
sp2 <- aggregated_data_species[2,2:5]
row_id <- c(1,2,aggregated_data_species$sp)
 
aggregated_data_species <- rbind(min1,max2,sp1,sp2)
row.names(aggregated_data_species) <- row_id

radarchart(aggregated_data_species)
