setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/mean_trait_match/")

all_net_NR = read.csv("all_net_non_random.csv", header = T)
all_net_NR = all_net_NR[,-1]
all_net_R = read.csv("all_net_random.csv", header= T)
all_net_R = all_net_R[,-1]

inf_01_NR = all_net_NR[which(all_net_NR$ext_rate== 1),]
inf_01_R = all_net_R[which(all_net_R$ext_rate== 1),]

inf_01_dif = inf_01_NR$mean_trait_match - inf_01_R$mean_trait_match
inf_01_dif = as.data.frame(inf_01_dif)

ggplot(inf_01_dif, aes(x=inf_01_dif)) +
  geom_histogram(fill = "blue", color = "black", alpha = 0.7) +
  geom_vline(xintercept = 0, color = "red", linetype = "dashed", size = 1) +
  labs(title = "Extinction Rate = 1.0", x = expression(Delta * "Mean Trait"), y = "Frequency") +
  theme_classic()

ggsave("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/delta_traitmatch_extrates/ext_rate_1.pdf")


