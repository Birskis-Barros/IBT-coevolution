function profitability_ext(adj_network, trait, total_island_species, a_fit, b_fit, g_fit, threshold, StDevProfit)

    Splants = size(adj_network)[1]; #number of plants
    Spollinator = size(adj_network)[2]; #number of pollinator
    n_S = Splants + Spollinator; #total number of species

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

    #Calculating trait-matching among species on the island
    trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;
    trait_mat = abs.(copy(trait_mat));

    ##Calculating the mean and var of z_dif
    E_z = zeros(n_S);
    Var_z = zeros(n_S);

    for i=1:n_S
      E_z[i] = mean(trait_mat[i,findall(!iszero, trait_mat[i,:])]);
      Var_z[i] = (std(trait_mat[i,findall(!iszero, trait_mat[i,:])]))^2;
    end

    ##Replace NaN for zero in Var_z
    Var_z[findall(isnan, Var_z)] .= 0;

    ##Feed into E{P} equation
    #Parameters

    Exp_Prof = (g_fit .*
        ((n_S .* a_fit.^2) .+
        (2 .*n_S .*a_fit .*b_fit .*E_z) .+
        (b_fit^2 .* ((n_S .* (E_z.^2)) .+ Var_z))) ./

        (n_S.*(a_fit .+ (b_fit.*E_z)).^3));

    # extrema(Exp_Prof)

    ##Calculating the probability of extinction - see file Pext_ErrorFunction.nb


    pt = (Exp_Prof .- threshold) ./ (sqrt(2).*StDevProfit);

    result = [erfc(x) for x in pt]

    Pr_Extinction = 0.5 .* result

    #To chose which species will get extinct
    vec_p_relativ = Pr_Extinction[total_island_species] ./ sum(Pr_Extinction[total_island_species]);
    vec_p = cumsum(vec_p_relativ);
    dice1 = rand();
    pick_vec_p = Int64[findfirst(x->x==1, dice1 .< vec_p)];
    pri_ext = total_island_species[pick_vec_p]

return(
pri_ext
)

end
