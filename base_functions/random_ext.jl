function random_ext(adj_network, trait, total_island_species, alfa, baseline_ext)

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


    trait_mat = (square_colonizer_network.*trait)' -  square_colonizer_network.*trait;
    prob_ext = zeros(size(total_island_species)[1]) .+1;
    pass_test1 = zeros(size(prob_ext)[1]);

    ## Extinction due to baseline extinction rate related to island size

    pass_test2 = zeros(size(prob_ext)[1]) .+1;
    base_ext = repeat([baseline_ext], size(prob_ext)[1]);
    roll_dice_2 = rand(Uniform(0,1),size(prob_ext)[1]);
    pass_test2 = pass_test2 .* (roll_dice_2 .< base_ext);

    ## Among all possible species, just one will get extinct
    final_pass_test = pass_test1 .+ pass_test2;
    sp = final_pass_test .> 0;

    if findall(x->x>0,sp) == []
        global pri_ext = 0;
    else
        global pri_ext = total_island_species[rand(findall(x->x>0,sp), 1)];
    end

    return(
    pri_ext
    )
end
