using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames
using JLD2

loadfunc = include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/loadfuncs.jl") #start everytime with this

phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 5000; #total number of events
n_start_plants = 1 #initial number of plants in the island (it will be the same number of polinators)
ext_rate = 0.25; # extinction rate (related to the size of the island)
baseline_ext = 0.2; #probability of ext that all sp have regardless traitmtaching
col_rate = 1; ##colonization rate
coev_rate = 1 #coevolutionary rate
k = 0.01; #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)
para_x = 0.2;

for i=1:54

    R"""
        result = matrix(NA, ncol=5, nrow=20)
        result = as.data.frame(result)
        colnames(result) = c("network", "mean_mainlad", "std_mainland", "mean_island", "std_island")
        result[,1] = $i #change for the number of network
        result$ext_rate = 0.25
    """

    m = i
    filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
    adj_network = CSV.read(filename,header=false,DataFrame);
    adj_network = Array(adj_network);
    adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
    Splants = size(adj_network)[1]; #number of plants
    Spollinator = size(adj_network)[2]; #number of pollinator
    n_S = Splants + Spollinator; #total number of species

    for j=1:20
        z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, baseline_ext, ext_rate, col_rate, coev_rate, events)[1];
        mean_main = mean(z_final[:,1]);
        sd_main = std(z_final[:,1]);
        find_nonzero_sp = z_final[findall(!iszero, z_final[:, events]),events]
        mean_isl_sp = mean(find_nonzero_sp)
        sd_isl_sp = std(find_nonzero_sp)

        R"""
            result[$j,2] = $(mean_main)
            result[$j,3] = $(sd_main)
            result[$j,4] = $(mean_isl_sp)
            result[$j,5] = $(sd_isl_sp)
        """
    end

R"""
    path_file = "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/new/sd_mean_z_island/random/ext_025/"
    filename = paste(path_file, "network", $i, ".csv", sep="")
    write.csv(result, file=filename)
"""
end
