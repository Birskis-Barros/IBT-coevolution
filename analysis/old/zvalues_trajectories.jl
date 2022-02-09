#### Analysing the CV (=sd/mean) of species richness in the island with different values of col_rate  ####


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

m=8
filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events); #plants and then animals

trajlist = Array{Array{Float64}}(undef,0) # this array will save the trajectories

splist = Array{Int64}(undef,0) #this array will save the species correspondent to each trajectory

timelist = Array{Int64}(undef,0) # this array will save in what event does that trajectory starts (colonization event)

diff_matrix = copy(z_result);

for u=1:size(z_result)[1]
      sp = diff_matrix[u,:]
      sp[1] = 0.0

      traj = copy(sp)
      traj[traj.!=0] .= 1

      #diff(Int64.(traj .> 0)) #finding when it colonizes (=1) and when it gets extinct (-1)

      ev_col = findall(x->x==1,diff(Int64.(traj .> 0))) .+ 1  #events of colonization
      ev_ext = findall(x->x==-1,diff(Int64.(traj .> 0))) #events of extinction

      if size(ev_col)[1] > size(ev_ext)[1]
            ev_col = ev_col[1:size(ev_ext)[1]]
      else size(ev_col)[1] < size(ev_ext)[1]
            ev_ext = ev_ext[1:size(ev_col)[1]]
      end

      for i=1:size(ev_ext)[1]
            coe_traj = sp[ev_col[i]:ev_ext[i]]
            push!(trajlist,coe_traj)
            push!(splist,u)
            push!(timelist,ev_col[i])
      end
end

namespace = "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/trajectories/network8/z_result.jld"
@save namespace z_result

###### Stupid way to build the graph #####

trajlist[findall(x->x==19,splist)] ## searching the trajectories correspondence to species 4
tam = size(trajlist[findall(x->x==19,splist)])[1] #how many trajectories

#Graph with the last value of each trajectory and initial value (the same as z of species in the mainland)

trying = zeros(tam*2, 2);
trying[[1:1:tam;],1] = last.(trajlist[findall(x->x==19,splist)]) ; #final values
trying[[1:1:tam;],2] .= 2;

trying[[(tam+1):1:(2*tam);],1] .= z_result[19,1]; #initial values
trying[[(tam+1):1:(2*tam);],2] .= 1;

R"""
teste = as.data.frame($(Array(trying)))
teste$traj = rep(1:(dim(teste)[1]/2), 2)
teste$V2 = as.character(teste$V2)

g4 = ggplot(teste, aes(x=V2, y=V1, group=traj)) +
   geom_line() +
   geom_hline(yintercept =  0.4168576598989401, colour = "blue") +
   theme_classic() +
   labs(y="Mean Species Trait (Z)", x="")  +
   scale_x_discrete(labels=c("1" = "Initial", "2"= "Final")) +
   theme(axis.title=element_text(size=16), axis.text.x = element_text(vjust = 1, size = 12), axis.text.y = element_text(vjust = 1, size = 12))


   g1,g4,g5,g49,g48,g47

   library("ggpubr") # combining graphs

   figure = ggarrange(g1,g4,g5,g49,g48,g47,
      ncol=3, nrow=2)


      name = paste("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/z_trait/trajectories.pdf")

      ggsave(name, width=7.92, height=5.49)

"""
