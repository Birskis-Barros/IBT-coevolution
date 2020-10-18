cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/coevolution_mainland.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/casc_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/initial_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/first_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/colonization.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/coev_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/all_dynamics.jl")

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames


phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
tmax = 500; #coevolutionary time step
ext_size = 0.1; #baseline extinction rate
col_rate = 1.0; ## defining colonization rate
maximumprob = 0.10; ## maximum probability of extinction based on trait matching

m = 8; #chossing network from data folder

#### Empirical Network
filename = string("network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);

#each col is on timestep (column1 is the traits of species in the island, other columns are time steps)
#species that aren't in the island at that time step are "zeros", if they are the number is their trait value at that timestep.
#ncolumns = tmax 
analy = assemblycoev(adj_network, phi, mi, alfa, tmax, ext_size, col_rate, maximumprob);
