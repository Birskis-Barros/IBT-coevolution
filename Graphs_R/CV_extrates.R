### Plot graph CV (or Mean CV) for different ext rates and non-random x random ext

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/CV/")

library("ggplot2")
library(ggpubr)

str_net = read.csv("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/network_structure.csv", 
                   header=T)

d_R_03 = read.csv("random_03_result_cv.csv", header=T)
d_R_03 = d_R_03[,-1]
#d_R_03 = aggregate(cv ~ network, data = d_R_03, FUN = mean) #to plot the mean for network
d_R_03$type = "random"
d_R_03$ext_rate = 0.3


d_R_06 = read.csv("random_06_result_cv.csv", header=T)
d_R_06 = d_R_06[,-1]
#d_R_06 = aggregate(cv ~ network, data = d_R_06, FUN = mean)#to plot the mean for network
d_R_06$type = "random"
d_R_06$ext_rate = 0.6

d_R_09 = read.csv("random_09_result_cv.csv", header=T)
d_R_09 = d_R_09[,-1]
#d_R_09 = aggregate(cv ~ network, data = d_R_09, FUN = mean)#to plot the mean for network
d_R_09$type = "random"
d_R_09$ext_rate = 0.9

d_NR_03 = read.csv("non_random_03_result_cv.csv", header=T)
d_NR_03 = d_NR_03[,-1]
#d_NR_03 = aggregate(cv ~ network, data = d_NR_03, FUN = mean)#to plot the mean for network
d_NR_03$type = "non-random"
d_NR_03$ext_rate = 0.3

d_NR_06 = read.csv("non_random_06_result_cv.csv", header=T)
d_NR_06 = d_NR_06[,-1]
#d_NR_06 = aggregate(cv ~ network, data = d_NR_06, FUN = mean)#to plot the mean for network
d_NR_06$type = "non-random"
d_NR_06$ext_rate = 0.6

d_NR_09 = read.csv("non_random_09_result_cv.csv", header=T)
d_NR_09 = d_NR_09[,-1]
#d_NR_09 = aggregate(cv ~ network, data = d_NR_09, FUN = mean)#to plot the mean for network
d_NR_09$type = "non-random"
d_NR_09$ext_rate = 0.9

d_all = rbind(d_R_03, d_R_06, d_R_09, d_NR_03, d_NR_06, d_NR_09)

d_all[,5:10] = NA
colnames(d_all)[5:10] = colnames(str_net)[2:7]

for (i in 1:54){

    d_all$Connect[which(d_all$network == i)] = str_net$Connect[str_net$X == i]
    d_all$Links_per_sp[which(d_all$network == i)] = str_net$Links_per_sp[str_net$X == i]
    d_all$Richness[which(d_all$network == i)] = str_net$Richness[str_net$X == i]
    d_all$Mod[which(d_all$network == i)] = str_net$Mod[str_net$X == i]
    d_all$NODF[which(d_all$network == i)] = str_net$NODF[str_net$X == i]
    d_all$Densit[which(d_all$network == i)] = str_net$Densit[str_net$X == i]

}

# ggplot(d_all[d_all$ext_rate==0.3,], aes(x=NODF, y=cv, group=type, color=type)) +
#   geom_point(size=3) +
#   #scale_color_manual(labels = c("Non-random", "Random"), values=c("darkslategray4", "darkmagenta")) +
#   #geom_smooth(aes(color = 0000type), method = "lm", se = FALSE)  +
#   #ylim(0,0.4) +
#   #xlim(0,250) +
#   #stat_cor(label.y = c(0.03, 0.008), label.x.npc = 0.05) + 
#   guides(size=12, color=guide_legend("Type of Extinction")) +
#   ylab("Mean CV") +
#   xlab("NODF") +
#   theme_classic() +
#   theme(text = element_text(size=18))

d_all$ext_rate = as.character(d_all$ext_rate)

ggplot(d_all, aes(x=ext_rate, y=cv, fill=type)) +
  #geom_point(aes(fill=type), size = 5, shape = 21, position = position_jitterdodge(), alpha=0.25) +
  geom_boxplot(color="black" )  +
  scale_fill_manual(values = c("darkseagreen4", "darkorange"), name="Type of extinction",
                    breaks=c("non-random", "random"),
                    labels=c("Trait-based", "Random")) +
  scale_color_manual(values = c("darkseagreen4", "darkorange")) +
  ylim(0,10) +
  labs(title = "", x = "Extinction Rate", y = "CV") +
  theme_classic() +
  scale_x_discrete(labels = c("0.3" = "Low", "0.6" = "Medium", "0.9" = "High"))+
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12))  # Adjust the font size and style for plot title+)

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/cv_ylim10.pdf")

