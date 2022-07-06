#### Exploring the relationship between primary and secundary extinxtions and the degree of sp

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
ext_rate = 0.4; # extinction rate (related to the size of the island)
baseline_ext = 0.4; #probability of ext that all sp have regardless traitmtaching 
col_rate = 1; ##colonization rate
coev_rate = 1 #coevolutionary rate
k = 0.2; #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)
para_x = 0.3; #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)

m=1 #network number
filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

result_ext_data = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, baseline_ext, ext_rate, col_rate, coev_rate, events)[3];

### Analyzing primary extinctions 
first_ext = copy(result_ext_data)

first_ext[findall(x->x==2, first_ext)] .= 0
sp_n_first = sum(first_ext, dims=2)

Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator;
zero_plant = zeros(Splants, Splants);
zero_pollinator = zeros(Spollinator, Spollinator);
a = hcat(zero_plant, adj_network);
b = hcat(adj_network', zero_pollinator);
square_adj_network = vcat(a,b); #square matrix = plants + pollinator
sp_degree = sum(square_adj_network, dims=2); #species degree

result_first_ext = hcat(sp_degree, sp_n_first)

R"""
result_first_ext = as.data.frame($(Array(result_first_ext)))
colnames(result_first_ext) = c("degree", "n_first")

g_f = ggplot(result_first_ext, aes(x=degree, y=n_first)) +
geom_point() + 
ylim(0,14) + 
xlab("Degree") +
ylab("Number of Primary Extinctions") +
theme_classic()
"""

### Analyzing secondary extinctions

sec_ext = copy(result_ext_data)

sec_ext[findall(x->x==1, first_ext)] .= 0
sp_n_sec = sum(sec_ext, dims=2)./2

result_sec_ext = hcat(sp_degree, sp_n_sec)

R"""
result_sec_ext = as.data.frame($(Array(result_sec_ext)))
colnames(result_sec_ext) = c("degree", "n_sec")

g_s = ggplot(result_sec_ext, aes(x=degree, y=n_sec)) +
geom_point() + 
ylim(0,14) +
xlab("Degree") +
ylab("Number of Secunday Extinctions") +
theme_classic()

figure = ggarrange(g_f, g_s, ncol=2, nrow=1)

ggsave("network_1.pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Pos_Quals/first_and_secondary_ext/", width=20, height = 10)


"""