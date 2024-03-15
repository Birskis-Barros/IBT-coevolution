### Analyzis CV richness with the structure of mainland network

library(ggplot2)
library(ggpubr)

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/CV/")

## File with the structure of the networks
struct = read.csv("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/network_structure.csv", 
                  header=T)

##Reading the .csv for both random and non-random ext
all_data_r  = read.csv("random_06_result_cv.csv", header=T) #random
all_data_r = na.omit(all_data_r)#excluding NA
all_data_nr = read.csv("non_random_06_result_cv.csv", header=T) #non-random
all_data_nr = na.omit(all_data_nr)#excluding NA

##Calculating the mean CV for all simulations for each network
cv_net_nr = matrix(NA, ncol=2, nrow=54)
cv_net_nr = as.data.frame(cv_net_nr)
colnames(cv_net_nr) = c("network", "mean_cv")
cv_net_nr$network = 1:54
cv_net_nr$type_ext = "non_random"


for (i in 1:54){
  cv_net_nr$mean_cv[i] = mean(all_data_nr$cv[which(all_data_nr$network == i )])
}

#Combining the info of mean CV and the structure of networks
cv_net_nr = cbind(cv_net_nr, struct)

##Calculating the mean CV for all simulations for each network
cv_net_r = matrix(NA, ncol=2, nrow=54)
cv_net_r = as.data.frame(cv_net_r)
colnames(cv_net_r) = c("network", "mean_cv")
cv_net_r$network = 1:54
cv_net_r$type_ext = "random"


for (i in 1:54){
  cv_net_r$mean_cv[i] = mean(all_data_r$cv[which(all_data_r$network == i )])
}

#Combining the info of mean CV and the structure of networks
cv_net_r = cbind(cv_net_r, struct)

## Combing the info of non-random ext and random ext
all_result = rbind(cv_net_nr, cv_net_r) 

##Plotting 
n_s = ggplot(all_result, aes(x=Links_per_sp, y=mean_cv, group=type_ext, color=type_ext)) +
  geom_point(size=3) +
  scale_color_manual(labels = c("Non-random", "Random"), values=c("darkslategray4", "darkmagenta")) +
  geom_smooth(aes(color = type_ext), method = "lm", se = FALSE)  +
  ylim(0,1) +
  #xlim(0,250) +
  stat_cor(label.y = c(0.9, 0.85), label.x.npc = 0.6) + 
  guides(size=12, color=guide_legend("Type of Extinction")) +
  ylab("Mean CV") +
  xlab("Links per species") +
  theme_classic() +
  theme(text = element_text(size=18))

ggsave(n_s, file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/cv_struct_mainland_net/ext_rate_06/Link_06.pdf")


  