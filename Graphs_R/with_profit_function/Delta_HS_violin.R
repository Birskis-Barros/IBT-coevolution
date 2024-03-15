setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/HS_potential_degree/ext_06/")

hs_NR_1 = read.csv("1_10_half_net_NR_06.csv", header=T)
hs_NR_2 = read.csv("11_20_half_net_NR_06.csv", header=T)
hs_NR_3 = read.csv("21_30_half_net_NR_06.csv", header=T)
hs_NR_4 = read.csv("31_40_half_net_NR_06.csv", header=T)
hs_NR_5 = read.csv("41_54_half_net_NR_06.csv", header=T)

hs_NR = rbind(hs_NR_1, hs_NR_2, hs_NR_3, hs_NR_4, hs_NR_5)
hs_NR$type = "Trait-based"
hs_NR$rate = "0.6"

hs_R_1 = read.csv("1_10_half_net_R_06.csv", header=T)
hs_R_2 = read.csv("11_20_half_net_R_06.csv", header=T)
hs_R_3 = read.csv("21_30_half_net_R_06.csv", header=T)
hs_R_4 = read.csv("31_40_half_net_R_06.csv", header=T)
hs_R_5 = read.csv("41_54_half_net_R_06.csv", header=T)

hs_R = rbind(hs_R_1, hs_R_2, hs_R_3, hs_R_4, hs_R_5)
hs_R$type = "Random"
hs_R$rate = "0.6"

hs_06 = hs_NR$HS-hs_R$HS
hs_06 = as.data.frame(hs_06)
hs_06$rate = "0.6"
colnames(hs_06) = c("diff", "rate")

hs_all = rbind(hs_03,hs_06,hs_09)

ggplot(hs_all, aes(x=rate, y=diff)) +
  geom_violin(aes(fill = rate), trim = FALSE, alpha=0.7)  +
  scale_fill_brewer(palette="Dark2") +
  geom_boxplot(width = 0.1) +
  ylim(-2,2) +
  theme_classic() +
  theme(legend.position = "none") +
  labs(title = "", x = "Extinction Rate", y = expression(Delta * S[0])) +
  scale_x_discrete(labels = c("0.3" = "Low", "0.6" = "Medium", "0.9" = "High"))+
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/Delta_S0_violin.pdf")


