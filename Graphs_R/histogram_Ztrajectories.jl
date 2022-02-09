R"""

trying = as.data.frame($(Array(trying)))

final_traits = trying[which(trying$V2==2),]
initial_trait = trying[which(trying$V2==1),]

### Plants

gen_p = ggplot(final_traits, aes(x=V1)) +
 geom_histogram(aes(y = stat(count / sum(count))), fill="#5BB300") +
 ylim(0,0.25) +
 geom_vline(initial_trait, xintercept = mean(initial_trait$V1), linetype="dotted") +
 theme_classic() +
 ylab("Frequency") +
 xlab("Final Trait") +
 theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14))

### Pollinators

sp_pol = ggplot(final_traits, aes(x=V1)) +
 geom_histogram(aes(y = stat(count / sum(count))), fill="#CF78FF") +
 ylim(0,0.25) +
 geom_vline(initial_trait, xintercept = mean(initial_trait$V1), linetype="dotted") +
 theme_classic() +
 ylab("Frequency") +
 xlab("Final Trait") +
 theme(axis.text=element_text(size=12),
                axis.title=element_text(size=14))


library("ggpubr")

figure <- ggarrange(g1,g2,g7,g4,g5,g6,g12,g13,g14,g15,g16,g17,
          labels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"),
          ncol = 6, nrow =2 )

ggsave("plant_pollinator.pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/trajectories/network8/", width=20, height = 10)

 ggsave("traj_sp19.pdf", g19, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/trajectories/network8", width=20, height = 10)

"""
figure <- ggarrange(spec_p,gen_p,sp_pol,gen_pol,
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow =2 )
