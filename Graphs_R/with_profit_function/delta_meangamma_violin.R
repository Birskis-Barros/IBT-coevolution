setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/mean_trait_match/")

all_net_NR = read.csv("all_net_non_random.csv", header = T)
all_net_NR = all_net_NR[,-1]
all_net_R = read.csv("all_net_random.csv", header= T)
all_net_R = all_net_R[,-1]

inf_03_NR = all_net_NR[which(all_net_NR$ext_rate== 0.3),]
inf_03_R = all_net_R[which(all_net_R$ext_rate== 0.3),]

inf_06_NR = all_net_NR[which(all_net_NR$ext_rate== 0.6),]
inf_06_R = all_net_R[which(all_net_R$ext_rate== 0.6),]

inf_09_NR = all_net_NR[which(all_net_NR$ext_rate== 0.9),]
inf_09_R = all_net_R[which(all_net_R$ext_rate== 0.9),]

inf_03_dif = inf_03_NR$mean_trait_match - inf_03_R$mean_trait_match
inf_03_dif = as.data.frame(inf_03_dif)
inf_03_dif$rate = 0.3
colnames(inf_03_dif) = c("diff", "rate")

inf_06_dif = inf_06_NR$mean_trait_match - inf_06_R$mean_trait_match
inf_06_dif = as.data.frame(inf_06_dif)
inf_06_dif$rate = 0.6
colnames(inf_06_dif) = c("diff", "rate")

inf_09_dif = inf_09_NR$mean_trait_match - inf_09_R$mean_trait_match
inf_09_dif = as.data.frame(inf_09_dif)
inf_09_dif$rate = 0.9
colnames(inf_09_dif) = c("diff", "rate")

all_dif = rbind(inf_03_dif, inf_06_dif, inf_09_dif)

all_dif$rate = as.character(all_dif$rate)

ggplot(all_dif, aes(x=rate, y=diff)) +
  geom_violin(aes(fill = rate), trim = FALSE, alpha=0.6)  +
  geom_boxplot(width = 0.2) +
  scale_fill_brewer(palette="Dark2") +
  #stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "white", color = "black") +
  ylim(-0.04,0.02) +
  geom_hline(yintercept = 0, linetype="dotted", 
             color = "black", size=1.5) +
  theme_classic() +
  theme(legend.position = "none") +
  labs(title = "", x = "Extinction Rate", y = expression(Delta * bar(gamma))) +
  scale_x_discrete(labels = c("0.3" = "Low", "0.6" = "Medium", "0.9" = "High"))+
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12))  # Adjust the font size and style for plot title+)

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/Delta_MeanGamma.pdf")

data_03 = rbind(inf_03_NR, inf_03_R)
data_06 = rbind(inf_06_NR, inf_06_R)
data_09 = rbind(inf_09_NR, inf_09_R)

mean_03_NR = mean(inf_03_NR$mean_trait_match, na.rm=TRUE)
mean_03_R = mean(inf_03_R$mean_trait_match, na.rm=TRUE)

mean_06_NR = mean(inf_06_NR$mean_trait_match, na.rm=TRUE)
mean_06_R = mean(inf_06_R$mean_trait_match, na.rm=TRUE)

mean_09_NR = mean(inf_09_NR$mean_trait_match, na.rm=TRUE)
mean_09_R = mean(inf_09_R$mean_trait_match, na.rm=TRUE)


ggplot(data_09, aes(x=mean_trait_match, fill=type_ext)) +
  geom_histogram(alpha=0.7) +
  scale_fill_manual(values=c("#69b3a2", "#404080"), labels = c("Trait-based", "Random")) +
  #geom_vline(xintercept = mean_03_NR , color="#69b3a2", linetype="dashed", size=1.5) +
  #geom_vline(xintercept= mean_03_R, color="#404080",  linetype="dashed", size=1.5) +
  labs(fill = "Type of extinction") +
  xlim(0.11,0.24) +
  ylim(0,15) +
  labs(title = "Extinction Rate = 09", x = expression( bar(gamma)), y = "Count") +
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 
  
ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/Hist_MeanGamma_09.pdf")

all = rbind(inf_03_NR, inf_03_R, inf_06_NR, inf_06_R, inf_09_NR, inf_09_R)
all$ext_rate = as.character(all$ext_rate)

ggplot(all, aes(x=ext_rate, y=mean_trait_match, color=type_ext)) +
  geom_boxplot() +
  labs(color = "Type of extinction") +
  scale_color_manual(values=c("#69b3a2", "#404080"), labels = c("Trait-based", "Random")) +
  scale_x_discrete(labels = c("0.3" = "Low", "0.6" = "Medium", "0.9" = "High")) +
  theme_classic() +
  labs(title = "", x = "Extinction Rate", y = expression(bar(gamma))) +
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12))  # Adjust the font size and style for plot title+)

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/boxplot_MeanGamma_extrate.pdf")

