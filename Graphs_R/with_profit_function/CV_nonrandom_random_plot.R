#####   Plot non-random X random CV 

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/CV/")

library("ggplot2")
library(ggpubr)

d_R_03 = read.csv("random_03_result_cv.csv", header=T)
d_R_03 = d_R_03[,-1]
d_R_03 = aggregate(cv ~ network, data = d_R_03, FUN = mean) #to plot the mean for network
colnames(d_R_03) = c("network", "cv_random")

d_NR_03 = read.csv("non_random_03_result_cv.csv", header=T)
d_NR_03 = d_NR_03[,-1]
d_NR_03 = aggregate(cv ~ network, data = d_NR_03, FUN = mean) #to

d_R_03$cv_nonramdon = d_NR_03$cv
d_03 = d_R_03

d_R_03$network == d_NR_03$network

g03 = ggplot(d_03, aes(x=cv_random, y=cv_nonramdon)) +
  geom_point(size=3) +
  xlim(0,0.5) +
  ylim(0,0.5) +
  geom_abline(intercept = 0, slope = 1, color = "darkorchid") +
  labs(title = "Extinction Rate = 0.3", x = "Mean CV - Random", y = "Mean CV - Trait-based") +
  theme_classic() +
  theme(axis.text = element_text(size = 12), 
        axis.title = element_text(size = 14),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 16)) + # Adjust the font size and style for plot title+
  guides(color = FALSE) 
  theme_classic() 
  
#______________________________________________________________

d_R_06 = read.csv("random_06_result_cv.csv", header=T)
d_R_06 = d_R_06[,-1]
d_R_06 = aggregate(cv ~ network, data = d_R_06, FUN = mean) #to plot the mean for network
colnames(d_R_06) = c("network", "cv_random")

d_NR_06 = read.csv("non_random_06_result_cv.csv", header=T)
d_NR_06 = aggregate(cv ~ network, data = d_NR_06, FUN = mean) #to

d_R_06$network == d_NR_06$network

d_06 = matrix(NA, ncol=3, nrow=54)
d_06 = as.data.frame(d_06)
colnames(d_06) = c("network", "cv_random", "cv_nonrandom")
d_06$network = 1:54

#Pay attention to the size 

#length(d_R_06$network) = 45
for (i in 1:45){
  d_06$cv_random[which(d_06$network == d_R_06$network[i])] = d_R_06$cv_random[i]
}

#length(d_NR_06$network) = 45
for (i in 1:45){
  d_06$cv_nonrandom[which(d_06$network == d_NR_06$network[i])] = d_NR_06$cv[i]
}

g06 = ggplot(d_06, aes(x=cv_random, y=cv_nonrandom)) +
  geom_point(size=3) +
  xlim(0,1) +
  ylim(0,1) +
  geom_abline(intercept = 0, slope = 1, color = "darkorchid") +
  labs(title = "Extinction Rate = 0.6", x = "Mean CV - Random", y = "Mean CV - Trait-based") +
  theme_classic() +
  theme(axis.text = element_text(size = 12), 
        axis.title = element_text(size = 14),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 16)) + # Adjust the font size and style for plot title+
  guides(color = FALSE) 

#______________________________________________________________

d_R_09 = read.csv("random_09_result_cv.csv", header=T)
d_R_09 = d_R_09[,-1]
d_R_09 = aggregate(cv ~ network, data = d_R_09, FUN = mean) #to plot the mean for network
colnames(d_R_09) = c("network", "cv_random")

d_NR_09 = read.csv("non_random_09_result_cv.csv", header=T)
d_NR_09 = aggregate(cv ~ network, data = d_NR_09, FUN = mean) #to


d_09 = matrix(NA, ncol=3, nrow=54)
d_09 = as.data.frame(d_09)
colnames(d_06) = c("network", "cv_random", "cv_nonrandom")
d_09$network = 1:54

#length(d_R_09$network) = 36
for (i in 1:36){
  d_09$cv_random[which(d_09$network == d_R_09$network[i])] = d_R_09$cv_random[i]
}

#length(d_NR_09$network) = 39
for (i in 1:39){
  d_09$cv_nonrandom[which(d_09$network == d_NR_09$network[i])] = d_NR_09$cv[i]
}

g09 = ggplot(d_09, aes(x=cv_random, y=cv_nonrandom)) +
  geom_point(size=3) +
  xlim(0,3) +
  ylim(0,3) +
  geom_abline(intercept = 0, slope = 1, color = "darkorchid") +
  labs(title = "Extinction Rate = 0.9", x = "Mean CV - Random", y = "Mean CV - Trait-based") +
  theme_classic() +
  theme(axis.text = element_text(size = 12), 
        axis.title = element_text(size = 14),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 16)) + # Adjust the font size and style for plot title+
  guides(color = FALSE) 

#________________________________

figure = ggarrange(g03,g06,g09,
          ncol=3, nrow=1)

ggsave(figure, file="/Users/irinabarros/Desktop/figure.pdf",  width = 14, height = 6)
