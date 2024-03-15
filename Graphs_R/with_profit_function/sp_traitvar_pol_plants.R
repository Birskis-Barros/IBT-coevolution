setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/sp_trait_variance/")

library("ggplot2")

data_NR = read.csv("NR_sp_var_traj_net1_54.csv", header=T)
data_NR = data_NR[,-1]
data_NR$type_ext = "Non_random"
data_R = read.csv("R_sp_var_traj_net1_54.csv", header=T)
data_R$type_ext = "Random"

data_NR$V1[is.na(data_NR$V1)] <- 0
data_R$V1[is.na(data_R$V1)] <- 0
data_pol_NR = data_NR[data_NR$type=="pol",]
data_pol_R = data_R[data_R$type=="pol",]

data_pol_R$tV2 = as.character(log(data_pol_R$V2))

poli_NR = ggplot(data_pol_R, aes(x=tV2, y=V1))+
  geom_boxplot(color="#CF78FF") +
 #scale_color_manual(values=c("#5BB300")) +
  #"#CF78FF"), labels = c("Plants", "Pollinators")) +
  ylim(0,0.005) +
  theme_classic() +
  xlab("Log Sp Degree") +
  ylab("Evolutionary Sp Trait Variance") +
  labs(color="Group") +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14))

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/sp_trait_variance/plants_R.pdf")


library("ggpubr")

figure = ggarrange(pl_NR, pl_R, poli_NR, poli_R, ncol=2, nrow=2)

ggsave("pol_plant_ext.pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/sp_trait_variance/", width=11, height = 6.5)
