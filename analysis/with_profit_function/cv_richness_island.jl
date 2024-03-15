#### Exploring Island' richness

if homedir() == "/Users/irinabarros"
  localpath::String = "$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/";
elseif homedir() == "/home/irinabarros"
  localpath::String = "$(homedir())/IBT_coev/IBT-coevolution/base_functions/";
end

#load all necessary functions
include(localpath*"loadfuncs.jl");

phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 5000; #total number of events
n_start_plants = 1 #initial number of plants in the island (it will be the same number of polinators)
ext_rate = 0.3; # extinction rate (related to the size of the island)
col_rate = 1; ##colonization rate
coev_rate = 1 #coevolutionary rate

###For the PrExt_Error function
##Calculating Exp_Prof
a_fit = 1
b_fit = 1
g_fit = 100

##Calculating Pr of Extinction

##Random ext
threshold = 250
StDevProfit = 0.7

##Non random ext
threshold = 96.5
StDevProfit = 38.5

## Number of network to check

R"""
result_cv = matrix(NA, ncol=2, nrow=540)
result_cv = as.data.frame(result_cv)
colnames(result_cv) = c("network", "cv")
result_cv$network = rep(1:54,each=10)

"""

numb_net = 54

  for l=1:numb_net #from network 1 to numb_net
      if homedir() == "/Users/irinabarros"
          filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",l,".csv");
      elseif homedir() == "/home/irinabarros"
          filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",l,".csv");
      end

      adj_network = CSV.read(filename,header=false,DataFrame);
      adj_network = Array(adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

      Splants = size(adj_network)[1]; #number of plants
      Spollinator = size(adj_network)[2]; #number of pollinator
      n_S = Splants + Spollinator; #total number of species

      #time_steps = [5000, 4900, 4800, 4700, 4600, 4500, 4400, 4300, 4200, 4100, 4000];
      #name_folder = ["Sim1", "Sim2", "Sim3", "Sim4", "Sim5", "Sim6", "Sim7", "Sim8", "Sim9", "Sim10"];

      for i=1:10
          z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1];

          z_result[z_result.>0] .= 1 ;# focusing on the richness
          freq_sp = sum(z_result, dims=1);
          cv = std(freq_sp[3000:5000])/mean(freq_sp[3000:5000])

          #for m = 1:size(time_steps)[1]

            #  step = time_steps[m];
             # z_step = z_result[:,step];
             # sp_step = findall(!iszero, z_step);
             # pollinators = sp_step[sp_step .> Splants] .- Splants;
             # plants = sp_step[sp_step .<= Splants];

             # network_step = adj_network[plants, pollinators];
             # @rput network_step;

              #R"""
              #name_step = paste0("matrix_", $step, ".csv")
              #write.csv(network_step, file = paste0("/home/irinabarros/IBT_coev/Results/Random/", $name_folder[$i], "/", name_step), row.names = FALSE)
              #"""
          #end

          R"""
          loc = which(result_cv$network == $l)
          result_cv[loc[$i], 2] = $cv
          write.csv(result_cv, file=paste0("/home/irinabarros/IBT_coev/Results/non_random_03_result_cv.csv"))
          """

      end

   end


   R"""
   list_net[[1]] = network_5000
   """
