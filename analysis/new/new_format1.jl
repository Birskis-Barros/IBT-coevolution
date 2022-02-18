


loadfunc = include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/loadfuncs.jl") #start everytime with this 


phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 10000; #total number of events
n_start_plants = 4 #initial number of plants in the island (it will be the same number of polinators)
ext_rate = 0.3; # extinction rate (related to the size of the island)
baseline_ext = 0.2; #probability of ext that all sp have regardless traitmtaching 
col_rate = 0.7; ##colonization rate
k = 0.01 #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)
para_x = 0.2 #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)

m = 12 #empirical network that I'm using 
filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events);