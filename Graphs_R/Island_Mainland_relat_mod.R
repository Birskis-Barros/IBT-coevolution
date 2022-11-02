#### Making the graphs relative - continuation from "Island_Mainland_Networks_figure.R
### For modulatiry ######

relat = matrix(NA, ncol=4, nrow=400)
relat = as.data.frame(relat)

colnames(relat) = c("network", "mod_island", "mod_main", "type_ext")
relat$network = rep(seq(1,10), each=40)
relat$type_ext = rep(c("random", "trait_match"), each=20, 10) 

relat[1:40,2] = net_combined$modularity.Q[which(net_combined$network==1)]/mainland$modularity.Q[which(mainland$X==1)]
relat[41:80,2] = net_combined$modularity.Q[which(net_combined$network==2)]/mainland$modularity.Q[which(mainland$X==2)]
relat[81:120,2] = net_combined$modularity.Q[which(net_combined$network==3)]/mainland$modularity.Q[which(mainland$X==3)]
relat[121:160,2] = net_combined$modularity.Q[which(net_combined$network==4)]/mainland$modularity.Q[which(mainland$X==4)]
relat[161:200,2] = net_combined$modularity.Q[which(net_combined$network==5)]/mainland$modularity.Q[which(mainland$X==5)]
relat[201:240,2] = net_combined$modularity.Q[which(net_combined$network==6)]/mainland$modularity.Q[which(mainland$X==6)]
relat[241:280,2] = net_combined$modularity.Q[which(net_combined$network==7)]/mainland$modularity.Q[which(mainland$X==7)]
relat[281:320,2] = net_combined$modularity.Q[which(net_combined$network==8)]/mainland$modularity.Q[which(mainland$X==8)]
relat[321:360,2] = net_combined$modularity.Q[which(net_combined$network==9)]/mainland$modularity.Q[which(mainland$X==9)]
relat[361:400,2] = net_combined$modularity.Q[which(net_combined$network==10)]/mainland$modularity.Q[which(mainland$X==10)]

relat$mod_main[1:40] = mainland$modularity.Q[1] 
relat$mod_main[41:80] = mainland$modularity.Q[2] 
relat$mod_main[81:120] = mainland$modularity.Q[3] 
relat$mod_main[121:160] = mainland$modularity.Q[4]
relat$mod_main[161:200] = mainland$modularity.Q[5]
relat$mod_main[201:240] = mainland$modularity.Q[6]
relat$mod_main[241:280] = mainland$modularity.Q[7]
relat$mod_main[281:320] = mainland$modularity.Q[8]
relat$mod_main[321:360] = mainland$modularity.Q[9]
relat$mod_main[361:400] = mainland$modularity.Q[10]

relat$network = as.character(relat$network)

g2 = ggplot(relat, aes(x=network, y=mod_island)) +
  geom_boxplot(color="azure4") +
  geom_jitter(alpha=0.4,width=0.25, color="azure4") +
  #geom_point(aes(y=mainland$modularity.Q[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$modularity.Q[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_hline(yintercept = 1, linetype="dashed", color="black") +
  ylab("Modularity.Q") +
  xlab("Networks") +
  #guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

ggsave( file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Pos_Quals/Island_Mainland_Networks/relatice_modularity.Q.pdf")

