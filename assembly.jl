
####### Assembly Process:
##### Colonization

sp_a = findall(x->x>0, adj_network[:,start_pollinators[1]]);
sp_b = findall(x->x>0, adj_network[:, start_pollinators[2]]);
sp_ab = setdiff([sp_a;sp_b], start_plants); #possible plants to colonize

sp_c = findall(x->x>0, adj_network[start_plants[1],:]);
sp_d = findall(x->x>0, adj_network[start_plants[2],:]);
sp_cd =   Splants .+ setdiff([sp_c;sp_d],start_pollinators); # possible pollinators to colonize

sp_colonizer = sample([sp_ab;sp_cd],1)[1]; # choosing one sp from all the possible new colonizers

#to know if it's a plant or a pollinator
if sp_colonizer > Splants
    new_pollinators = sort([start_pollinators; (sp_colonizer - Splants)]);
    new_plants = start_plants;
else
    new_plants = sort([start_plants; sp_colonizer]);
    new_pollinators = start_pollinators;
end


island_species = [new_plants,(Splants.+new_pollinators)];
z_newcolonizer = z_result[sp_colonizer,1]; #grabbing the z of the new colonizer (from mainland)

colonizer_network = zeros(size(adj_network)[1], size(adj_network)[2]);
colonizer_network[new_plants,new_pollinators] = adj_network[new_plants,new_pollinators]; #new network in the island (with the new species)

## Square matrix for the new community
new_zero_plant = zeros(size(colonizer_network)[1], size(colonizer_network)[1]);
new_zero_pollinator = zeros(size(colonizer_network)[2], size(colonizer_network)[2]);
new_a = hcat(new_zero_plant, colonizer_network);
new_b = hcat(colonizer_network', new_zero_pollinator);
square_colonizer_network = vcat(new_a,new_b);

####### Coevolutionary dynamic

total_island_species = [island_species[1]; island_species[2]];
new_theta = zeros(n_S);
new_theta[total_island_species] = island_THETA[total_island_species]; #grabbing the theta for the species that are in the island

new_M = repeat([mi],outer= size(square_colonizer_network)[1]);
new_PHI = repeat([phi], outer= size(square_colonizer_network)[1]);

#definir o z do primeito time step + o z da nova especie que colonizou

new_species = [findall(x->x>0, z_result[:,4]); sp_colonizer] 
new_z = zeros(n_S)
new_z[new_species] = [z_result[findall(x->x>0, z_result[:,2]),2]; z_newcolonizer];

global new_Q = Array{Float64}(undef, 0);
    #for i = 1:(tmax-1)
    #ini_z = ini_pool_z_matrix[i,:];
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
    z_result[new_species,3] = z_final[new_species];
