


loadfunc = include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/loadfuncs.jl") #start everytime with this


phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 10000; #total number of events
n_start_plants = 4 #initial number of plants in the island (it will be the same number of polinators)
ext_rate = 0.3; # extinction rate (related to the size of the island)
baseline_ext = 0.25; #probability of ext that all sp have regardless traitmtaching
col_rate = 1; ##colonization rate
coev_rate = 1; #coevolutionary rate
k = 0.01; #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)
para_x = 0.2; #parameter in the traitmatch_ext function (related to the fuction of probability of extinction based on trait matching)

result_025 = zeros(80,10000);
delta_025 = zeros(80,10000);


for l=41:80
    filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",l,".csv");
    adj_network = CSV.read(filename,header=false,DataFrame);
    adj_network = Array(adj_network);
    adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
    result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, baseline_ext, ext_rate, col_rate, coev_rate, events);
    z_result = result[1];
    z_result[z_result.!=0] .= 1
    result_025[l,:] = sum(z_result, dims=1);
    delta_025[l,:] = result[2]
end


findall(x->x>0, result_025[:,2])

result_025 = as.data.frame($(Array(result_025)))
write.csv(result_025, "/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/richness/pos_quals/result_025.csv")
