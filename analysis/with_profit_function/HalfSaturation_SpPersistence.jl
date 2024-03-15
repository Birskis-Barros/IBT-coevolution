#### Finding half saturation point for species persistence X degree

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

  #Random
  threshold = 250
  StDevProfit = 0.7

  R"""
  #library("drc")
  half_net = matrix(NA, ncol=3,nrow=280)
  half_net = as.data.frame(half_net)
  colnames(half_net) = c("network", "HS", "SP")
  half_net$network = rep(41:54,each=20)

  """

  for m=41:54
    if homedir() == "/Users/irinabarros"
           filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
       elseif homedir() == "/home/irinabarros"
           filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",m,".csv");
       end

    adj_network = CSV.read(filename,header=false,DataFrame);
    adj_network = Array(adj_network);
    adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

    for i=1:20

        z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1];

        c_result = copy(z_final);
        c_result = c_result[:, 1:end .!= 1]; #excluding first column because it represents the mainland
        c_result[c_result.>0] .= 1; #to focus on the presence of species in each event
        sp_persistence = sum(c_result, dims=2); #number of times the species was present in the total number of events
        perc_pers = sp_persistence ./events; #percentage of persistence. If 1 means that the species was there all the time

        ### To find species degree
        #Creating a square matrix
        Splants = size(adj_network)[1]; #number of plants
        Spollinator = size(adj_network)[2]; #number of pollinator
        n_S = Splants + Spollinator;
        zero_plant = zeros(Splants, Splants);
        zero_pollinator = zeros(Spollinator, Spollinator);
        a = hcat(zero_plant, adj_network);
        b = hcat(adj_network', zero_pollinator);
        square_adj_network = vcat(a,b); #square matrix = plants + pollinator
        sp_degree = sum(square_adj_network, dims=2); #species degree
        sp_result = hcat(sp_degree, perc_pers); #combining information

        #Finding half saturation point
        R"""
        #sp_result_03 = $sp_result
        #colnames(sp_result_03) = c("degree", "persistance")
        #write.csv(sp_result_03, file="/home/irinabarros/IBT_coev/Results/sp_result_03.csv")

            sp_result = as.data.frame($(Array(sp_result)))

            y = sp_result$V2
            x = sp_result$V1

            model <- try(nls(y ~ (a*x)/(b + x),start = list(a=0.75,b=5)))
            if (!inherits(model, "try-error")) {
            loc = which(half_net$network == $m)
            half_net[loc[$i], 2] = summary(model)$coefficients[2, 1] #half-saturation point
            half_net[loc[$i], 3] = summary(model)$coefficients[1, 1] #saturation point
          } else {
            half_net[loc[$i], 2] = NA
          }
            write.csv(half_net, file="/home/irinabarros/IBT_coev/Results/41_54_half_net_NR_09.csv")
        """
    end
  end
