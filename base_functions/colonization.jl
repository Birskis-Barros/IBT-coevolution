function colonization(adj_network, total_island_species)

    Splants = size(adj_network)[1]; #number of plants

    pollinators = total_island_species[total_island_species .> Splants] .- Splants;
    plants = total_island_species[total_island_species .<= Splants];

    spol = Array{Array}(undef, length(pollinators))
    for i=1:length(pollinators)
    spol[i] = findall(x->x>0, adj_network[:,pollinators[i]]);
    end

    if spol == []
        possible_plants = copy(plants);
    else
        possible_plants = sort(unique(reduce(vcat, spol)));
    end

    spla = Array{Array}(undef, length(plants))
    for i=1:length(plants)
    spla[i] = findall(x->x>0, adj_network[plants[i],:]);
    end

    if spla == []
        possible_pollinators  = copy(pollinators);
    else
        possible_pollinators = sort(unique(reduce(vcat, spla)));
    end

    sp_ab = setdiff(possible_plants, plants); #possible plants to colonize
    sp_cd =   Splants .+ setdiff(possible_pollinators,pollinators); # possible pollinators to colonize

    species_colonizer = sample([sp_ab;sp_cd],1)[1]; # choosing one sp from all the possible new colonizers


    return(
    species_colonizer
    )

end
