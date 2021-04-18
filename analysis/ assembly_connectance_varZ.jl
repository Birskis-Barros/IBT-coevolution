##### Analyzing the structure of the network while community assembly ####


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
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/analysis/gillespie_connectance.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/initial_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/potential_colonizers.jl")

phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 10000; #total number of events
n_start_plants = 4 #initial number of plants in the island (it will be the same number of polinators)
ext_size = 0.3; #baseline extinction rate
col_rate = 0.8; ##colonization rate
maximumprob = 0.10; ## maximum probability of extinction based on trait matching

#### Empirical Network

      m = 1
      filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
      adj_network = CSV.read(filename, header=false);
      adj_network = convert(Array,adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

      sim = gillespie_connectance(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events);
      z_result = sim[1];
      connectance = sim[2];

      var_z = zeros(1,events)
      for i = 1:10000
      var_z[1,i] = var(z_result[findall(!iszero,z_result[:,i]),i])
      end

      """
      library("ggplot2")

      connectance = as.data.frame($(Array(connectance)))
      connectance = t(connectance)
      var_z = as.data.frame($(Array(var_z)))
      var_z = t(var_z)

      result = cbind(connectance, var_z)
      result = as.data.frame(result)

      a = 1:10000
      result = cbind(result,a)
      result$a = as.character(result$a)

      colnames(result) = c("connectance", "var_z", "event")

      ggplot(result, aes(y=connectance, x=event))+
      geom_point() +
      theme_classic()
