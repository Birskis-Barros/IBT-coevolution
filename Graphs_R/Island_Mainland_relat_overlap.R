#### Making the graphs relative - continuation from "Island_Mainland_Networks_figure.R
### For niche.overlap.LL ######

relat = matrix(NA, ncol=4, nrow=400)
relat = as.data.frame(relat)

colnames(relat) = c("network", "niche_island", "niche_main", "type_ext")
relat$network = rep(seq(1,10), each=40)
relat$type_ext = rep(c("random", "trait_match"), each=20, 10) 

relat[1:40,2] = net_combined$niche.overlap.LL[which(net_combined$network==1)]/mainland$niche.overlap.LL[which(mainland$X==1)]
relat[41:80,2] = net_combined$niche.overlap.LL[which(net_combined$network==2)]/mainland$niche.overlap.LL[which(mainland$X==2)]
relat[81:120,2] = net_combined$niche.overlap.LL[which(net_combined$network==3)]/mainland$niche.overlap.LL[which(mainland$X==3)]
relat[121:160,2] = net_combined$niche.overlap.LL[which(net_combined$network==4)]/mainland$niche.overlap.LL[which(mainland$X==4)]
relat[161:200,2] = net_combined$niche.overlap.LL[which(net_combined$network==5)]/mainland$niche.overlap.LL[which(mainland$X==5)]
relat[201:240,2] = net_combined$niche.overlap.LL[which(net_combined$network==6)]/mainland$niche.overlap.LL[which(mainland$X==6)]
relat[241:280,2] = net_combined$niche.overlap.LL[which(net_combined$network==7)]/mainland$niche.overlap.LL[which(mainland$X==7)]
relat[281:320,2] = net_combined$niche.overlap.LL[which(net_combined$network==8)]/mainland$niche.overlap.LL[which(mainland$X==8)]
relat[321:360,2] = net_combined$niche.overlap.LL[which(net_combined$network==9)]/mainland$niche.overlap.LL[which(mainland$X==9)]
relat[361:400,2] = net_combined$niche.overlap.LL[which(net_combined$network==10)]/mainland$niche.overlap.LL[which(mainland$X==10)]

relat[1:40,3] = mainland$niche.overlap.LL[1] 
relat[41:80,3] = mainland$niche.overlap.LL[2] 
relat[81:120,3] = mainland$niche.overlap.LL[3] 
relat[121:160,3] = mainland$niche.overlap.LL[4]
relat[161:200,3] = mainland$niche.overlap.LL[5]
relat[201:240,3] = mainland$niche.overlap.LL[6]
relat[241:280,3] = mainland$niche.overlap.LL[7]
relat[281:320,3] = mainland$niche.overlap.LL[8]
relat[321:360,3] = mainland$niche.overlap.LL[9]
relat[361:400,3] = mainland$niche.overlap.LL[10]

relat$network = as.character(relat$network)

f2 = ggplot(relat, aes(x=network, y=niche_island)) +
  geom_boxplot(color="darkolivegreen4") +
  geom_jitter(alpha=0.4,width=0.25, color="darkolivegreen4") +
  #geom_point(aes(y=mainland$niche.overlap.LL[1], x="1"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[2], x="2"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[3], x="3"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[4], x="4"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[5], x="5"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[6], x="6"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[7], x="7"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[8], x="8"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[9], x="9"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  #geom_point(aes(y=mainland$niche.overlap.LL[10], x="10"), color="black", shape=17, size=2.5, show.legend=FALSE) +
  geom_hline(yintercept = 1, linetype="dashed") +
  ylab("Niche Overlap LL") +
  xlab("Networks") +
  ylim(0.5,1.75) +
  #guides(color=guide_legend(title="Type of Extinction")) +
  scale_color_brewer(palette="Accent") +
  theme(text = element_text(size = 18)) +
  theme_classic()

fig_niche = ggarrange(f1,f2,ncol=2,nrow=1, common.legend = T)
ggsave(fig_niche, file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Pos_Quals/Island_Mainland_Networks/nicheoverlap_structure_networks.pdf", width=12, height=8)

