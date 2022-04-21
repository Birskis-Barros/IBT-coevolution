function traitmatch_ext(adj_network, trait, total_island_species, alfa, baseline_ext, para_x, k)

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
    int_position = Vector{Vector{Int64}}(undef, n_S);
    for a in 1:n_S
        int_position[a] = findall(x->x==1,square_colonizer_network[a,:]);
    end

    #Calculating trait-matching among species on the island 
    trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;
    sp_mean_traitmatch = Vector{Float64}(undef, n_S);
    for b in 1:n_S
     sp_mean_traitmatch[b] =  mean(abs.(trait_mat[b,int_position[b]]));
    end

    which_sp_interact = findall(!isnan,sp_mean_traitmatch); #species that have interactions

    mean_sp_mismatch = 1 .- sp_mean_traitmatch; #trait mismatch of species

    ##Calculating the probability of extinction 
    prob_ext_sp = zeros(n_S);

        #para_x define where in the x axis "the curve begin" and k define how fast the curve saturates (see file "curve_trait_ext_nb")
        for u in 1:n_S
            prob_ext_sp[u] = baseline_ext + (1 - (baseline_ext))/(1+exp(-(mean_sp_mismatch[u]-para_x)/k))
        end    
    

        #To chose which species will get extinct
        vec_p_relativ = prob_ext_sp[which_sp_interact] ./ sum(prob_ext_sp[which_sp_interact]);
        vec_p = cumsum(vec_p_relativ);
        dice1 = rand();
        pick_vec_p = Int64[findfirst(x->x==1, dice1 .< vec_p)];
        pri_ext = which_sp_interact[pick_vec_p]

    
    return(
    pri_ext
    )
end
