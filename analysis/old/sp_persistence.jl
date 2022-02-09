
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
ext_size = 0.5; #baseline extinction rate
col_rate = 1.0; ##colonization rate
maximumprob = 0.10; ## maximum probability of extinction based on trait matching

m = 12
filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events);

c_result = copy(z_result)
c_result = c_result[:, 1:end .!= 1] #excluding first column because it represents the mainland
c_result[c_result.>0] .= 1 #to focus on the presence of species in each event
sp_persistence = sum(c_result, dims=2) #number of times the species was present in the total number of events
perc_pers = sp_persistence ./events #percentage of persistence. If 1 means that the species was there all the time

##Creating a square matrix
Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator;
zero_plant = zeros(Splants, Splants);
zero_pollinator = zeros(Spollinator, Spollinator);
a = hcat(zero_plant, adj_network);
b = hcat(adj_network', zero_pollinator);
square_adj_network = vcat(a,b); #square matrix = plants + pollinator

sp_degree = sum(square_adj_network, dims=2)

sp_result = hcat(sp_degree, perc_pers)

R"""
library("ggplot2")
library("ggpubr")

sp_result = as.data.frame($(Array(sp_result)))

#change g object according to network m
g12 = ggplot(sp_result, aes(x=V1, y=V2))+
  geom_point() +
  geom_smooth() +
  labs(x = "Species Degree", y = "Species Persistence", size = 24) +
  theme(axis.text.x = element_text(vjust = 1, size = 30), axis.text.y = element_text(vjust = 1, size = 30)) +
  theme_classic()

  figure <- ggarrange(g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,
            labels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"),
            ncol = 4, nrow = 3)

  ggsave("sp_pers_network1to12.pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/sp_persistence/", width=20, height = 10)

"""
