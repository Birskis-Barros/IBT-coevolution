#### Finding realized species degree (mean degree over 'events') on island x persistence on island

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
  ext_rate = 0.5 #ext rate

  ###For the Profitability Extinction
  a_fit = 1
  b_fit = 1
  g_fit = 100

  ##Non random ext
  threshold = 96.5
  StDevProfit = 38.5

  #Random
  threshold = 250
  StDevProfit = 0.7

  R"""
  library("drc") #need?
  half_net_nr = matrix(NA, ncol=2,nrow=1080)
  half_net_nr = as.data.frame(half_net_nr)
  colnames(half_net_nr) = c("network", "HS")
  half_net_nr$network = rep(1:54,each=20)

  """

  for m=1:10
    if homedir() == "/Users/irinabarros"
           filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
       elseif homedir() == "/home/irinabarros"
           filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",m,".csv");
       end

    adj_network = CSV.read(filename,header=false,DataFrame);
    adj_network = Array(adj_network);
    adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

    Splants = size(adj_network)[1]; #number of plants
    Spollinator = size(adj_network)[2]; #number of pollinator
    n_S = Splants + Spollinator; #total number of species

    ##Creating a square matrix
    zero_plant = zeros(Splants, Splants);
    zero_pollinator = zeros(Spollinator, Spollinator);
    a = hcat(zero_plant, adj_network);
    b = hcat(adj_network', zero_pollinator);
    square_adj_network = vcat(a,b); #square matrix = plants + pollinator

    for i=1:20
          z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1];

          c_result = copy(z_final);
          c_result = c_result[:, 1:end .!= 1]; #excluding first column because it represents the mainland
          c_result[c_result.>0] .= 1; #to focus on the presence of species in each event
          sp_persistence = sum(c_result, dims=2); #number of times the species was present in the total number of events
          perc_pers = sp_persistence ./events; #percentage of persistence. If 1 means that the species was there all the time

          ### To find realized species degree on the island

          empty_df = copy(c_result);
          empty_df[empty_df.>0] .= 0;

          for u=1:size(c_result)[2]
              spid = findall(x->x==1, c_result[:,u]); #what species are on the island
              n_subnet = size(spid)[1];
              I = square_adj_network[spid,spid]; #matrix occurring on the island
              real_d = sum(I, dims=2); #finding the degree of species at that time
              empty_df[spid,u] = real_d;
           end

           mean_degree = [mean(filter(x -> x != 0, row)) for row in eachrow(empty_df)]; #finding the mean degree

           sp_result = hcat(mean_degree, perc_pers); #combining information

           #Finding half saturation point

           R"""
               sp_result = as.data.frame($(Array(sp_result)))

               y = sp_result$V2
               x = sp_result$V1

               model <- try(nls(y ~ (a*x)/(b + x),start = list(a=0.75,b=5)))
               if (!inherits(model, "try-error")) {
               loc = which(half_net_nr$network == $m)
               half_net_nr[loc[$i], 2] = summary(model)$coefficients[2, 1]
             } else {
               half_net_nr[loc[$i], 2] = NA
             }
               write.csv(half_net_nr, file="/home/irinabarros/IBT_coev/Results/1_10_half_net_R_06.csv")
           """
      end
  end
