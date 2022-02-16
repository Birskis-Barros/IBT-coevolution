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

    #Finding where the interactions are
    sp_int_position = Vector{Vector{Int64}}(undef, n_S)
    for a in 1:n_S
        sp_int_position[a] = findall(x->x==1,square_colonizer_network[a,:]);
    end

    #Calculating trait-matching among species on the island 
    trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;
    sp_mean_traitmatch = Vector{Float64}(undef, n_S)
    for b in 1:n_S
     sp_mean_traitmatch[b] =  mean(abs.(trait_mat[b,sp_int_position[b]]))
    end

    


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
        mean_sp_match =  Float64[(counts[i]>0 ? sums[i]/counts[i] : 0.0) for i in 1:n_S];
        mean_sp_mismatch = 1 .- mean_sp_match; #trait mismatch of species

        ##Calculating the probability of extinction 
        prob_ext_sp = zeros(n_S);

        for u in 1:n_S
            prob_ext_sp[u] = ext_size + (1 - (ext_size))/(1+exp(-(mean_sp_mismatch[u]-e)/k))
        end    

        #To chose which species will get extinct
        vec_p_relativ = prob_ext_sp ./ sum(prob_ext_sp);
        vec_p = cumsum(vec_p_relativ);
        dice1 = rand();
        pri_ext = Int64[findfirst(x->x==1, dice1 .< vec_p)];
    
    return(
    pri_ext
    )
end
