

if homedir() == "/Users/irinabarros"
  localpath::String = "$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/";
elseif homedir() == "/home/irinabarros"
  localpath::String = "$(homedir())/IBT_coev/IBT-coevolution/base_functions/";
end

#load all necessary functions
include(localpath*"loadfuncs.jl");

## Parameters
  phi = 0.1; #heritability
  mi = 0.4; #strength of biotic selection
  alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
  events = 5000; #total number of events
  n_start_plants = 1 #initial number of plants in the island (it will be the same number of polinators)
  col_rate = 1; ##colonization rate
  coev_rate = 1 #coevolutionary rate
  ext_rate = 0.9 #ext rate

  ###For the Profitability Extinction
  a_fit = 1
  b_fit = 1
  g_fit = 100

  ##Non random ext
  #threshold = 96.5
  #StDevProfit = 38.5

  ##Random
  threshold = 250
  StDevProfit = 0.7

for m=1:54 #number of networks in the analysis

      if homedir() == "/Users/irinabarros"
           filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
      elseif homedir() == "/home/irinabarros"
           filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",m,".csv");
      end

      adj_network = CSV.read(filename,header=false,DataFrame);
      adj_network = Array(adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix


      size_sec_ext = zeros((events-1),20)

      for n=1:20 #number of replicates

          z_result = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1]; #plants and then animals
          z_result[z_result .!= 0] .= 1; #focusing on the number of sp

          numb_sp = sum(z_result, dims=1);
          numb_sp = numb_sp[2:end]; # excluding first column (= mainland)
          mean_numb_sp = mean(numb_sp[4000:4999]) #normalized by the mean richness on the island

          #calculating the number of extinctions between steps
          for i=1:(size(numb_sp)[1]-1)
              if numb_sp[i+1] < numb_sp[i]
                  size_sec_ext[i,n] = (abs(numb_sp[i+1] - numb_sp[i])/mean_numb_sp)
              end
          end

      end

      R"""
      filename = paste("/home/irinabarros/IBT_coev/Results/Random/E_09/sec_", $m, "_R_09.csv", sep="")
      write.csv($size_sec_ext, file=filename)
      """
end
