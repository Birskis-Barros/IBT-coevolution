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

  ###For the Profitability Extinction
  a_fit = 1
  b_fit = 1
  g_fit = 100

for m=45:54
      filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",m,".csv");
      adj_network = CSV.read(filename,header=false,DataFrame);
      adj_network = Array(adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
      Splants = size(adj_network)[1]; #number of plants
      Spollinator = size(adj_network)[2]; #number of pollinator
      n_S = Splants + Spollinator; #total number of species

      n_rep = 50;
      possible_rates = collect(0:0.1:1);
      repeated_possible_rates = repeat(possible_rates, inner = n_rep);

      ## Loop for non_random ext and different extinction rates

      non_random = zeros(Float64, 3, size(possible_rates)[1]*n_rep);
      non_random[1,:] .= repeated_possible_rates;
      non_random[2,:] .= 1; # 1 will be non_random extinctions and 0 for random

      for i=1:size(non_random)[2]

        ##Non random ext
        threshold = 96.5
        StDevProfit = 38.5

        ext_rate = non_random[1,i]

        z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1];

        total_island_species = findall(!iszero, z_final[:,5000]);

        pollinators = total_island_species[total_island_species .> Splants] .- Splants;
        plants = total_island_species[total_island_species .<= Splants];

        new_adj_network = zeros(Splants, Spollinator);
        new_adj_network[plants, pollinators] = adj_network[plants, pollinators];

        ##Creating a square matrix
        zero_plant = zeros(Splants, Splants);
        zero_pollinator = zeros(Spollinator, Spollinator);
        a = hcat(zero_plant, new_adj_network);
        b = hcat(new_adj_network', zero_pollinator);
        square_colonizer_network = vcat(a,b); #square matrix = plants + pollinator

        #Finding where the interactions are
        int_position = Vector{Vector{Int64}}(undef, n_S);
        for a in 1:n_S
            int_position[a] = findall(x->x==1,square_colonizer_network[a,:]);
        end

        trait = z_final[:,5000];

        #Calculating trait-matching among species on the island
        trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;
        trait_mat = abs.(copy(trait_mat));

        sp_mean_trait = [mean(filter(x -> x != 0, row)) for row in eachrow(trait_mat)];

        com_mean_trai = mean(sp_mean_trait[sp_mean_trait.>0]);

        non_random[3,i] = com_mean_trai;

      end

        R"""
        result_non_random = as.data.frame($(Array(non_random)))
        result_non_random = as.data.frame(t(result_non_random))
        result_non_random[,2] = "non_random"
        colnames(result_non_random) = c("ext_rate", "categories", "values")
        result_non_random$ext_rate = as.character(result_non_random$ext_rate)
        net = paste("/home/irinabarros/IBT_coev/Results/net_", $m, "_non_random.csv", sep="")
        write.csv(result_non_random, file=net)
        """

  end



    ______________________________________________________________________


      ## Loop for random ext and different extinction rates
  for m=45:54
      filename = string("$(homedir())/IBT_coev/Data_Pollination/pollination/network_",m,".csv");
      adj_network = CSV.read(filename,header=false,DataFrame);
      adj_network = Array(adj_network);
      adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix
      Splants = size(adj_network)[1]; #number of plants
      Spollinator = size(adj_network)[2]; #number of pollinator
      n_S = Splants + Spollinator; #total number of species

      n_rep = 50;
      possible_rates = collect(0:0.1:1);
      repeated_possible_rates = repeat(possible_rates, inner = n_rep);

      random = zeros(Float64, 3, size(possible_rates)[1]*n_rep);
      random[1,:] .= repeated_possible_rates;
      random[2,:] .= 0; # 1 will be non_random extinctions and 0 for random

    for i=1:size(random)[2]

      ##Random ext
      #Random
      threshold = 250
      StDevProfit = 0.7

      ext_rate = random[1,i]

      z_final = gillespie_algorithm(adj_network, phi, mi, alfa, n_start_plants, ext_rate, col_rate, coev_rate, events)[1];

      total_island_species = findall(!iszero, z_final[:,events]);

      pollinators = total_island_species[total_island_species .> Splants] .- Splants;
      plants = total_island_species[total_island_species .<= Splants];

      new_adj_network = zeros(Splants, Spollinator);
      new_adj_network[plants, pollinators] = adj_network[plants, pollinators];

      ##Creating a square matrix
      zero_plant = zeros(Splants, Splants);
      zero_pollinator = zeros(Spollinator, Spollinator);
      a = hcat(zero_plant, new_adj_network);
      b = hcat(new_adj_network', zero_pollinator);
      square_colonizer_network = vcat(a,b); #square matrix = plants + pollinator

      #Finding where the interactions are
      int_position = Vector{Vector{Int64}}(undef, n_S);
      for a in 1:n_S
          int_position[a] = findall(x->x==1,square_colonizer_network[a,:]);
      end

      trait = z_final[:,events];

      #Calculating trait-matching among species on the island
      trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;
      trait_mat = abs.(copy(trait_mat));

      sp_mean_trait = [mean(filter(x -> x != 0, row)) for row in eachrow(trait_mat)];

      com_mean_trai = mean(sp_mean_trait[sp_mean_trait.>0]);

      random[3,i] = com_mean_trai;

    end


      R"""
      result_random = as.data.frame($(Array(random)))
      result_random = as.data.frame(t(result_random))
      result_random[,2] = "random"
      colnames(result_random) = c("ext_rate", "categories", "values")
      result_random$ext_rate = as.character(result_random$ext_rate)
      net = paste("/home/irinabarros/IBT_coev/Results/net_", $m, "_random.csv", sep="")
      write.csv(result_random, file=net)
      """
end
      #
      #
      # result = rbind(result_non_random, result_random)
      #
      # ggplot(result_non_random, aes(x=ext_rate, y=values, color=categories)) +
      # geom_boxplot() +
      # ylab("Mean Trait-Mismatch of Island Community") +
      # xlab("Ext Rate") +
      # theme_classic()
