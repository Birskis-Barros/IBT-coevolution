function traitmatch_ext(adj_network, trait, total_island_species, alfa, ext_size)

    Splants = size(adj_network)[1]; #number of plants
    Spollinator = size(adj_network)[2]; #number of pollinator
    n_S = Splants + Spollinator; #total number of species

    pollinators = total_island_species[total_island_species .> Splants] .- Splants;
    plants = total_island_species[total_island_species .<= Splants];

    new_adj_network = zeros(Splants, Spollinator)
    new_adj_network[plants, pollinators] = adj_network[plants, pollinators]

    ##Creating a square matrix
    zero_plant = zeros(Splants, Splants);
    zero_pollinator = zeros(Spollinator, Spollinator);
    a = hcat(zero_plant, new_adj_network);
    b = hcat(new_adj_network', zero_pollinator);
    square_colonizer_network = vcat(a,b); #square matrix = plants + pollinator

    #Calculating trait-matching among species on the island 
    trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;

    #Calculating the mean of trait-matching of each species (non-zero values of trait_mat network)
           sums = zeros(n_S)
           counts = zeros(n_S)
           for c in 1:n_S
               for r in 1:n_S
                   v = abs.(trait_mat)[r,c]
                   if v > 0
                       sums[c] += v
                       counts[c] += 1.0
                   end
               end
           end
        mean_sp_match =  Float64[(counts[i]>0 ? sums[i]/counts[i] : 0.0) for i in 1:n_S]

        mean_sp_mismatch = 1 .- mean_sp_match #trait mismatch of species

        ##Calculating the probability of extinction 
        prob_ext_sp = zeros(n_S)

        for u in 1:n_S
            prob_ext_sp[u] = ext_size + (1 - (ext_size))/(1+exp(-(mean_sp_mismatch[u]-e)/k))
        end    



    return(
    pri_ext
    )
end
