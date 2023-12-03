#### Finding half saturation point for species persistence X degree

loadfunc = include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/base_functions/loadfuncs.jl") #start everytime with this

## Parameters
  phi = 0.1; #heritability
  mi = 0.4; #strength of biotic selection
  alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
  events = 5000; #total number of events
  n_start_plants = 1 #initial number of plants in the island (it will be the same number of polinators)
  col_rate = 1; ##colonization rate
  coev_rate = 1 #coevolutionary rate
  ext_rate = 0.55 #ext rate

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
  half_net = matrix(ncol=2,nrow=54)
  half_net = as.data.frame(half_net)
  """

  for m=42:54
    filename = string("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/network_",m,".csv");
    adj_network = CSV.read(filename,header=false,DataFrame);
    adj_network = Array(adj_network);
    adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

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

        sp_result = as.data.frame($(Array(sp_result)))

        m = $m

        y = sp_result$V2
        x = sp_result$V1

        model <- nls(y ~ (a*x)/(b + x),start = list(a=0.75,b=5))
        half_net[m,1] = round(summary(model)$coefficients[1,1],2) #saturation
        half_net[m,2] = summary(model)$coefficients[2,1] #half_point saturation

    """
  end
