

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames
using JLD2


include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/assemblycoev.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/casc_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coev_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/coevolution_mainland.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/colonization.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/first_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/gillespie_algorithm.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/initial_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/potential_colonizers.jl")

phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 10000; #total number of events
n_start_plants = 4 #initial number of plants in the island (it will be the same number of polinators)
ext_size = 0.3; #baseline extinction rate
col_rate = 0.7; ##colonization rate
maximumprob = 0.10; ## maximum probability of extinction based on trait matching

richness_c07 = zeros(10,events); #for 10 networks

  for l=1:10 #from network 1 to network 10

      m = l
      filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
      adj_network = CSV.read(filename, header=false);
      adj_network = convert(Array,adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
      z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events);

      z_result[z_result.>0] .= 1 ;# focusing on the richness

      richness = sum(z_result, dims=1);
      richness_c07[l,:] = richness ./ (richness[1,1])

   end

namespace = "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/richness/richness_c07.jld"
@save namespace richness_c07


R"""
     library(reshape2)
     library(ggplot2)
     library(tidyr)
     library("ggpubr")

     richness_c07 = as.data.frame($(Array(richness_c07)))
     richness_c07 = melt(richness_c07)
     richness_c07 = richness_c07[-c(1:10),] #removing the data related to the richness in the mainland
     richness_c07$network = rep(1:10,9999)
     richness_c07$event = rep(1:9999, each=10)

    richness_c07$network = as.character(richness_c07$network)

    net1_10 = richness_c1[which(richness_c1$network==c(1:10)),] #filtering networks

     c07_g1_10 = ggplot(net1_10, aes(x=event, y=value, color=network)) +
     geom_line() +
     ylim(0,1) +
     theme_classic() +
     xlab("Events") +
     ylab("Richness") +
     labs(color="Network") +
     theme(axis.text=element_text(size=20),
                    axis.title=element_text(size=20)) +
    theme(legend.title = element_text(size = 18),
                    legend.text = element_text(size = 14))

    ggsave("network1_10.pdf", path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/richness/")

    """

    ### For combining all the graphs together - for different graphs for distinct values of colonization and extinction

    #c01_g1_3, c07_g1_3,c1_g1_3 #graphs with 3 networks
    #c01_g1_5, c07_g1_5, c1_g1_5 #graphs with 5 networks
    #c01_g1_10, c07_g1_10, c1_g1_10 #graphs with 10 networks

     figure <- ggarrange(c01_g1_10,c07_g1_10,c1_g1_10,
               ncol = 3, nrow = 1)

      ggsave("B_network1_10.pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/richness/",
      width=30, height = 10)
