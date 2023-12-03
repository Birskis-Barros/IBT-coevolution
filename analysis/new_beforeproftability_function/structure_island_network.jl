#### Exploring the island network

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames
using JLD2

loadfunc = include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/loadfuncs.jl") #start everytime with this

R"""
library("bipartite")
"""

phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 5000; #total number of events
n_start_plants = 1 #initial number of plants in the island (it will be the same number of polinators)
ext_rate = 0.2; # extinction rate (related to the size of the island)
baseline_ext = 0.2; #probability of ext that all sp have regardless traitmtaching
col_rate = 1; ##colonization rate
coev_rate = 1 #coevolutionary rate
k = 0.01; #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)
para_x = 0.2;


m = 10
filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
adj_network = CSV.read(filename,header=false,DataFrame);
adj_network = Array(adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator; #total number of species

for i=1:20
    z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, baseline_ext, ext_rate, col_rate, coev_rate, events)[1];

    ###What is the community at time = event?
    community = copy(z_final[:,events]);
    community[community.>0] .= 1 ;#presence / absence
    sp_in_island = findall(x->x>0, community); #id sp

    ### What is the network?
    sp_pol = sp_in_island[sp_in_island .> Splants] .- Splants;
    sp_pla = sp_in_island[sp_in_island .<= Splants];

    island_net = zeros(Splants, Spollinator);
    island_net[sp_pla, sp_pol] = adj_network[sp_pla, sp_pol];

    R"""
    island_net = as.matrix($(Array(island_net)))
    index_net = networklevel(island_net, weighted=FALSE)

    path_file = "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/new/structure_network_island/ext_random/network10/"
    filename = paste(path_file, "rep", $i, ".csv", sep="")
    write.csv(index_net, file=filename)
    """
end
