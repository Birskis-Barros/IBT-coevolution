##### Trait matching extinction networks
setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/new/structure_network_island/ext_traitmatch/")

net1_trait = read.csv("network1_combined.csv", head=T)
all_net_trait = net1_trait

for (i in 3:10){
  file_name = paste("network", i, "_combined.csv", sep="")
  net_trait = read.csv(file_name, head=T)
  all_net_trait = rbind(all_net_trait, net_trait)
}

all_net_trait$type_ext = "trait_match"

##### Random extinction networks
setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/new/structure_network_island/ext_random/")

net1_rand = read.csv("network1_combined.csv", head=T)
all_net_rand = net1_rand

for (i in 2:10){
  file_name = paste("network", i, "_combined.csv", sep="")
  net_rand = read.csv(file_name, head=T)
  all_net_rand = rbind(all_net_rand, net_rand)
}

all_net_rand$type_ext = "random"

######### Combining information
all_net_rand$network = as.character(all_net_rand$network)
all_net_trait$network = as.character(all_net_trait$network)

mainland = mainland_net[1:10,]
mainland$X = as.character(mainland$X)
mainland = rbind(mainland, mainland)
mainland$type_ext = rep(c("random","trait_match"), each=10)

net_combined = rbind(all_net_rand, all_net_trait)

library("tidyverse")
library("RColorBrewer")

g1 = ggplot(net_combined, aes(x=network, y=connectance, color=type_ext)) +
  geom_boxplot() +
  geom_jitter(alpha=0.4,width=0.25, aes(color=type_ext)) +
  geom_point(aes(y=mainland$connectance[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$connectance[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  ylab("Connectance") +
  xlab("Networks") +
  guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

g2 = ggplot(net_combined, aes(x=network, y=modularity.Q, color=type_ext)) +
  geom_boxplot() +
  geom_jitter(alpha=0.4,width=0.25, aes(color=type_ext)) +
  geom_point(aes(y=mainland$modularity.Q[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$modularity.Q[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  ylab("Modularity") +
  xlab("Networks") +
  guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

g3 = ggplot(net_combined, aes(x=network, y=nestedness, color=type_ext)) +
  geom_boxplot() +
  geom_jitter(alpha=0.4,width=0.25, aes(color=type_ext)) +
  geom_point(aes(y=mainland$nestedness[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$nestedness[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  ylab("Nestedness") +
  xlab("Networks") +
  guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

g4 = ggplot(net_combined, aes(x=network, y=NODF, color=type_ext)) +
  geom_boxplot() +
  geom_jitter(alpha=0.4,width=0.25, aes(color=type_ext)) +
  geom_point(aes(y=mainland$NODF[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_point(aes(y=mainland$NODF[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  ylab("NODF") +
  xlab("Networks") +
  guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

figure = ggarrange(g1,g2,g3,g4,ncol=2,nrow=2)
ggsave(figure, file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Pos_Quals/Island_Mainland_Networks/structure_networks.pdf", width=12, height=8)

