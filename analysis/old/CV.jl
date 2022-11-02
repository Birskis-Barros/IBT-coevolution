#### Analysing the CV (=sd/mean) of species richness in the island with different values of col_rate  ####

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
n_start_plants = 4 #initial number of plants in the island (it will be the same number of polinators)
ext_size = 0.2; #baseline extinction rate
col_rate = [0.1:0.1:1;]; ##colonization rate
maximumprob = 0.10; ## maximum probability of extinction based on trait matching

result = zeros(550,4);
result[:,1] = repeat([1:1:55;], inner=10); #number of the networks: from 1 to 10
result[:,2] = repeat(col_rate, outer=55);

        for l=1:550
            #### Empirical Network
            m = Int64(result[l,1])
            filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
            adj_network = CSV.read(filename,header=false,DataFrame);
            adj_network = Array(adj_network);
            adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
            col_rate = result[l,2]
            z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, baseline_ext, ext_rate, col_rate, coev_rate, events);
            subset = copy(z_result[:,8000:events]) #taking just the last 2000 events
            subset[subset.>0] .= 1 #to focus on the presence of species in each event
            richness = sum(subset, dims=1) #number of species in each event
            result[l,3] = mean(richness)
            result[l,4] = std(richness)
        end

namespace = "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/CV/complete_2000.jld"

@save namespace result
