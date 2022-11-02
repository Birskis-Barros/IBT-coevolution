#### Making the graphs relative - continuation from "Island_Mainland_Networks_figure.R
### For connectance ######

relat_connect = matrix(NA, ncol=4, nrow=400)
relat_connect = as.data.frame(relat_connect)

colnames(relat_connect) = c("network", "connect_island", "connect_main", "type_ext")
relat_connect$network = rep(seq(1,10), each=40)
relat_connect$type_ext = rep(c("random", "trait_match"), each=20, 10) 

relat_connect[1:40,2] = net_combined$connectance[which(net_combined$network==1)]/mainland$connectance[which(mainland$X==1)]
relat_connect[41:80,2] = net_combined$connectance[which(net_combined$network==2)]/mainland$connectance[which(mainland$X==2)]
relat_connect[81:120,2] = net_combined$connectance[which(net_combined$network==3)]/mainland$connectance[which(mainland$X==3)]
relat_connect[121:160,2] = net_combined$connectance[which(net_combined$network==4)]/mainland$connectance[which(mainland$X==4)]
relat_connect[161:200,2] = net_combined$connectance[which(net_combined$network==5)]/mainland$connectance[which(mainland$X==5)]
relat_connect[201:240,2] = net_combined$connectance[which(net_combined$network==6)]/mainland$connectance[which(mainland$X==6)]
relat_connect[241:280,2] = net_combined$connectance[which(net_combined$network==7)]/mainland$connectance[which(mainland$X==7)]
relat_connect[281:320,2] = net_combined$connectance[which(net_combined$network==8)]/mainland$connectance[which(mainland$X==8)]
relat_connect[321:360,2] = net_combined$connectance[which(net_combined$network==9)]/mainland$connectance[which(mainland$X==9)]
relat_connect[361:400,2] = net_combined$connectance[which(net_combined$network==10)]/mainland$connectance[which(mainland$X==10)]

relat_connect$connect_main[1:40] = mainland$connectance[1] 
relat_connect$connect_main[41:80] = mainland$connectance[2] 
relat_connect$connect_main[81:120] = mainland$connectance[3] 
relat_connect$connect_main[121:160] = mainland$connectance[4]
relat_connect$connect_main[161:200] = mainland$connectance[5]
relat_connect$connect_main[201:240] = mainland$connectance[6]
relat_connect$connect_main[241:280] = mainland$connectance[7]
relat_connect$connect_main[281:320] = mainland$connectance[8]
relat_connect$connect_main[321:360] = mainland$connectance[9]
relat_connect$connect_main[361:400] = mainland$connectance[10]

relat_connect$network = as.character(relat_connect$network)

g1 = ggplot(relat_connect, aes(x=network, y=connect_island)) +
  geom_boxplot(color="azure4") +
  geom_jitter(alpha=0.4,width=0.25, color="azure4") +
  #geom_point(aes(y=mainland$connectance[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$connectance[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_hline(yintercept = 1, linetype="dashed", color="black") +
  ylab("Connectance") +
  xlab("Networks") +
  guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

ggsave( file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Pos_Quals/Island_Mainland_Networks/relatice_connectance.pdf")


