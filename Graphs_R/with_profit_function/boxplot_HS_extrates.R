### Replace for 0.3, 0.6, and 0.9

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/HS_potential_degree/ext_06/")

hs_NR_1 = read.csv("1_10_half_net_NR_06.csv", header=T)
hs_NR_2 = read.csv("11_20_half_net_NR_06.csv", header=T)
hs_NR_3 = read.csv("21_30_half_net_NR_06.csv", header=T)
hs_NR_4 = read.csv("31_40_half_net_NR_06.csv", header=T)
hs_NR_5 = read.csv("41_54_half_net_NR_06.csv", header=T)

hs_NR = rbind(hs_NR_1, hs_NR_2, hs_NR_3, hs_NR_4, hs_NR_5)
hs_NR$type = "Trait-based"
hs_NR$rate = "Medium"

hs_R_1 = read.csv("1_10_half_net_R_06.csv", header=T)
hs_R_2 = read.csv("11_20_half_net_R_06.csv", header=T)
hs_R_3 = read.csv("21_30_half_net_R_06.csv", header=T)
hs_R_4 = read.csv("31_40_half_net_R_06.csv", header=T)
hs_R_5 = read.csv("41_54_half_net_R_06.csv", header=T)

hs_R = rbind(hs_R_1, hs_R_2, hs_R_3, hs_R_4, hs_R_5)
hs_R$type = "Random"
hs_R$rate = "Medium"

mean(hs_NR$HS, na.rm=TRUE)

hs_06 = rbind(hs_NR, hs_R)

hs = rbind(hs_03, hs_06, hs_09)
hs$rate <- factor(hs$rate, levels = c("Low", "Medium", "High"))


ggplot(hs, aes(x=rate, y=HS, fill=type)) +
  geom_boxplot() +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2") +
  #stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "white", color = "black") +
  ylim(0,5) +
  theme_classic() +
  guides(color = FALSE) +
  labs(fill = "Type of extinction") +
  labs(title = "", x = "Extinction Rate", y = expression(S[0])) +
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12))

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/boxplot_HS.pdf")


# ggplot(hs_03, aes(x=HS,color=type, fill=type)) +
#   geom_histogram(position = "dodge", bins = 30, alpha = 0.4) +
#   scale_color_brewer(palette="Dark2") +
#   scale_fill_brewer(palette="Dark2") +
#   theme_classic() +
#   xlab(expression(S[0])) +
#   ggtitle("Extinction Rate = 0.9") +
#   ylab("Count") +
#   # xlim(-10,10) +
#   theme(axis.text = element_text(size = 16), 
#         axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
#         plot.title = element_text(size = 20), 
#         legend.title = element_text(size = 14),   # Adjust the size as needed
#         legend.text = element_text(size = 12)) +
#   guides(color = FALSE) +
#   labs(fill = "Type of extinction") 
# 
# ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/Freq_HS_09.pdf")
# 
#   