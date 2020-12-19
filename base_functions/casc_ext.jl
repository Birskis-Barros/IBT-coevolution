function cascade_ext_sp(adj_network, total_island_species, pri_ext)

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

    #plants + pollinators
    n_species = size(square_colonizer_network)[1];

    global ext_species = Array{Array}(undef, n_species)
    global ext_species[1] = copy(pri_ext)

    global ext_matrix = copy(square_colonizer_network);
    global ext_matrix[ext_species[1],:] .= 0; #removing all the interactions of ext_species - row
    global ext_matrix[:, ext_species[1]] .= 0; #removing all the interactions of ext_species - column

        for i = 2:n_species
            a = mapslices(sum, ext_matrix, dims = 2)[total_island_species]; #sp que só interagem com a sp extinta terão soma da linha = 0
            b = total_island_species[findall(x-> x .==0, a)];
            #c =  map(i->i[1], b);
            global ext_species[i] = b

            global ext_matrix[ext_species[i],:] .= 0; #removing all the interactions of ext_species - row
            global ext_matrix[:, ext_species[i]] .= 0; #remov

            if ext_species[i] == ext_species[i-1]
               break
           end
       end

    return(
    ext_species,
     #ext_matrix
     )
end
