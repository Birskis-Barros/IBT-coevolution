function coev_island(adj_network, total_island_species, new_z, alfa, mi, phi, new_theta);

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

    new_M = repeat([mi],outer= size(square_colonizer_network)[1]); #+
    new_PHI = repeat([phi], outer= size(square_colonizer_network)[1]); #+

    global new_Q = Array{Float64}(undef, 0);

        ## Calculating trait-matching
        new_z_dif = (square_colonizer_network.*new_z)' -  square_colonizer_network.*new_z;

        ##Calculating matrix Q
        global new_Q = square_colonizer_network.* (exp.(-alfa*(new_z_dif.^2)));
        global new_Q = new_Q./sum(new_Q,dims=2);

        ##Multplying by the strength of selection
        global new_Q = new_Q.*new_M;

        ##Multiplying by the z diff
        new_Q_z = new_Q .* new_z_dif;
        new_mut = vec(sum(new_Q_z,dims=2)); #normalizing

        ##Calculating the environmental selection dynamic
        new_env = (1 .-new_M).*(new_theta-new_z);

        ##Evolutionary dynamics (Coevolution+Environmental)
        z_final = new_z + new_PHI.*(new_mut + new_env);

        return (
            z_final
            )
end
