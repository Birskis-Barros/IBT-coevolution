function initial_island(adj_network, start_plants, THETA, z_result)

Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator;

## Randomly choosing 2 pollinators to first colonize the island, one for each plant.
global test_pollinators = 2

while test_pollinators > 1
    global start_pollinators = Array{Array}(undef, size(start_plants)[1])
    for i=1:length(start_plants)
     start_pollinators[i] = sample(findall(x->x>0, adj_network[start_plants[i],:]),1);
    end
    if length(unique(start_pollinators)) <  length(start_plants)
        global test_pollinators = 2
    else
        global test_pollinators = 0
    end
end


global start_pollinators = map(i->i[1], start_pollinators)

## The first network to colonize the island:
first_island_network = zeros(size(adj_network)[1], size(adj_network)[2]); #keeping the same size as pool network because it is easier to track species
for i=1:size(start_plants)[1]
first_island_network[start_plants[i],start_pollinators[i]] = 1;
end

##Grabbing the trait of those species in the equilibrium (mainland) #as primeiras especies são plantas
p = Splants .+ start_pollinators;
ini_sp_total = sort([start_plants; p]);
island_z_initial = zeros(n_S);
island_z_initial[ini_sp_total] = z_result[ini_sp_total,1];

## Square matrix for the initial community
ini_zero_plant = zeros(Splants, Splants);
ini_zero_pollinator = zeros(Spollinator, Spollinator);
a = hcat(ini_zero_plant, first_island_network);
b = hcat(first_island_network', ini_zero_pollinator);
square_first_island_network = vcat(a,b);

### Coevolutionary Dynamic for the Island with the initial species

island_THETA =  copy(THETA) #for now we are keepig the same theta for both mainland and island

ini_M = repeat([mi],outer= size(square_first_island_network)[1]);
ini_PHI = repeat([phi], outer= size(square_first_island_network)[1]);

#Initial trait value for each sp
ini_z = copy(island_z_initial);

global ini_Q = Array{Float64}(undef, 0);

    ini_z_dif = (square_first_island_network.*ini_z)' -  square_first_island_network.*ini_z;

    ##Calculating matrix Q
    global ini_Q = square_first_island_network .* (exp.(-alfa.*(ini_z_dif.^2)));
    global ini_Q = ini_Q./sum(ini_Q,dims=2);

    ##Multplying by the strength of selection
    global ini_Q = ini_Q.*ini_M;

    ##Multiplying by the z diff
    ini_Q_z = ini_Q .* ini_z_dif;
    ini_mut = vec(sum(ini_Q_z,dims=2)); #normalizing

    ##Calculating the environmental selection dynamic
    ini_env = (1 .-ini_M).*(island_THETA-ini_z);

    ##Evolutionary dynamics (Coevolution+Environmental)
    z_final = ini_z + ini_PHI.*(ini_mut + ini_env);
    #z_result[ini_sp_total,2] = z_final[ini_sp_total];

    return(
    ini_sp_total,
    square_first_island_network,
    #island_THETA,
    z_final
    )

end
