#Température et élévation
ggplot(data   = matrix_full_eco_elev_clim_sat,
       mapping = aes(x = temp ,
                     y = elevation  )) +   
  geom_point()
#graphe de base avec juste les points

 P <- ggplot(data   = matrix_full_eco_elev_clim_sat, mapping = aes(x = temp , y = elevation)) 

 P+geom_point()
 
 
 P + geom_point() +  geom_line() 
 
 P1 <-  P + geom_point() +  geom_line() 
#linges qui relient les points
 
P2 <-   P1+ geom_point() +  geom_line() +
labs(title    = "temperature vs. elevation",
     subtitle = "data from species niche",
     x        = "temperature in degree C",
     y        = "precipitation in mm ",
     caption  = "bidiversity data mining 2022")
 

 PF <- P2 + theme_bw() + theme(
   axis.title = element_text(colour = "blue", face = "bold"),
   plot.title = element_text(colour = "blue", face = "bold"),
   plot.subtitle = element_text(colour = "blue", face = "bold"))
#rajout des légendes, de la couleurs


 P <- ggplot(data = matrix_full_eco_elev_clim_sat, mapping = aes(x = temp, y = elevation)) +
   geom_point(shape = 16, size = 3, color = "blue") 

 P + geom_point(shape = 18, size = 3, color = "blue")  +
     geom_line(color = "red", linetype = 3) 
 
 
ppf <-  P + geom_point(shape = 16, size = matrix_full_eco_elev_clim_sat$temp, color = "blue")  +
   geom_line(color = "red", linetype = 3) 

print(ppf) 
#couleur des points et linges


 P <- ggplot(data   = matrix_full_eco_elev_clim_sat, mapping = aes(x = temp , y = elevation, color =sp)) 
 P + geom_point(shape = 18, size = 3)  +
   geom_line(linetype = 3) 
#différentes courbes des espèces
 
#Ensuite, les différentes espèces en fonction seulement de la température
 P_fact <- ggplot(data   = matrix_full_eco_elev_clim_sat, mapping = aes(x = sp, y = temp)) 
 
 P_fact + geom_point(shape = 18, size = 3)
 
 
#Boxplot
   
 P_fact <- ggplot(data   = matrix_full_eco_elev_clim_sat, mapping = aes(x = sp , y = temp)) 
 
 P_fact + geom_boxplot()


 P_fact + geom_boxplot(varwidth = TRUE, outlier.shape = NA) + ### change boxplot width 
   geom_jitter(alpha = 0.2, size = 2, width = 0.1) + # add points and spread point 
   stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") # add mean 
   
  
 
 P_fact + geom_boxplot(varwidth = TRUE, outlier.shape = NA) + ### change boxplot width 
   geom_jitter(alpha = 0.2, size = 2, width = 0.1) + # add points and spread point 
   stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") + # add mean 
   scale_fill_manual(values=cols)
 
 #avec les données
 

 
 P_fact <- ggplot(data   = matrix_full_eco_elev_clim_sat,  aes(y = temp , fill = sp)) 
 
 P_fact + geom_boxplot() 

#couleur!
 
#Lignes de régression
  P <- ggplot(data   = matrix_full_eco_elev_clim_sat, mapping = aes(x = temp , y = elevation, color =sp)) 
 
 P + geom_point(shape = 18) + 
     geom_smooth(method = "lm", se = FALSE)
 #lignes de régression des différentes espèces
 
#Hitogramme des températures
 ggplot(matrix_full_eco_elev_clim_sat, aes(x=temp)) +  ### change breaks
   geom_histogram(bins=100)
