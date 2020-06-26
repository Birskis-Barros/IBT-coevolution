cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall

####### The dynamic on the mainland ###########

t = 24; #starting the dynamic just for one network

filename = string("network_",t,".csv");
network_full = CSV.read(filename, header=false);
network_full = convert(Array,network_full);
network_full[network_full.>1] .= 1; #changing to a 0 and 1 matrix

## Paramenters
Splants = size(network_full)[1]; #number of plants
Spollinator = size(network_full)[2]; #number of pollinator
n_S = Splants + Spollinator;
phi = 0.25; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2;
tmax = 100;
M = repeat([mi],outer= n_S);
PHI = repeat([phi], outer= n_S);

##Creating a square matrix
zero_plant = zeros(Splants, Splants);
zero_pollinator = zeros(Spollinator, Spollinator);
a = hcat(zero_plant, network_full);
b = hcat(network_full', zero_pollinator);
new_network = vcat(a,b);

##Enviromental Optima
THETA = rand(Uniform(0,1), n_S);

#Initial trait value for each sp
z_initial = rand(Uniform(0,1), n_S);
z = copy(z_initial);

z_matrix = zeros(tmax, n_S);
z_matrix[1,:] = z;

global Q = Array{Float64}(undef, 0);
    for i = 1:(tmax-1)
    z = z_matrix[i,:];
    ## Calculating trait-matching
    z_dif = (new_network.*z)' -  new_network.*z;

    ##Calculating matrix Q
    global Q = new_network .* (exp(-alfa.*(z_dif.^2)));
    global Q = Q./sum(Q,dims=2);

    ##Multplying by the strength of selection
    global Q = Q.*M;

    ##Multiplying by the z diff
    Q_z = Q .* z_dif;
    mut = vec(sum(Q_z,dims=2)); #normalizing

    ##Calculating the environmental selection dynamic
    env = (1 .-M).*(THETA-z);

    ##Evolutionary dynamics (Coevolution+Environmental)
    z_matrix[i+1,:] = z + PHI.*(mut + env);
    end

###### The Dynamic in the Island #########
n_time = 100
z_result = zeros(n_S, n_time);
z_result[:,1] = z_matrix[tmax,:]; # The first colum is the trait value of species in the mainland


## Defining colonization rate
col_rate = 0.5;

## Randomly choosing 2 plant species
start_plants = sample(1:Splants,2);

## Randomly choosing 2 pollinators, one for each plant.
pollinator1 = sample(findall(x->x>0, network_full[start_plants[1],:]),1);
pollinator2 = sample(findall(x->x>0, network_full[start_plants[2],:]),1);
start_pollinators = [pollinator1; pollinator2];

## The first network to colonize the island:
start_network = network_full[start_plants, start_pollinators];

##Grabbing the trait of those species in the equilibrium (mainland)
p = Splants .+ start_pollinators;
p_total = [start_plants; p]; #vou usar isso pra preencher o z_result[,:2]
z_initial_island = z_matrix[100,p_total];

## Square matrix for the initial community
ini_zero_plant = zeros(2, 2);
ini_zero_pollinator = zeros(2, 2);
a = hcat(ini_zero_plant, start_network);
b = hcat(start_network', ini_zero_pollinator);
ini_new_network = vcat(a,b);

### Coevolutionary Dynamic for the Island with the initial species

##Enviromental Optima
ini_THETA = rand(Uniform(0,1), size(ini_new_network)[1]);

ini_M = repeat([mi],outer= size(ini_new_network)[1]);
ini_PHI = repeat([phi], outer= size(ini_new_network)[1]);

#Initial trait value for each sp
ini_z = copy(z_initial_island);

#ini_z_matrix = zeros(tmax, size(ini_new_network)[1]);
#ini_z_matrix[1,:] = ini_z;

global ini_Q = Array{Float64}(undef, 0);
    #for i = 1:(tmax-1)
    #ini_z = ini_z_matrix[i,:];
    ## Calculating trait-matching
    ini_z_dif = (ini_new_network.*ini_z)' -  ini_new_network.*ini_z;

    ##Calculating matrix Q
    global ini_Q = ini_new_network .* (exp(-alfa.*(ini_z_dif.^2)));
    global ini_Q = ini_Q./sum(ini_Q,dims=2);

    ##Multplying by the strength of selection
    global ini_Q = ini_Q.*ini_M;

    ##Multiplying by the z diff
    ini_Q_z = ini_Q .* ini_z_dif;
    ini_mut = vec(sum(ini_Q_z,dims=2)); #normalizing

    ##Calculating the environmental selection dynamic
    ini_env = (1 .-ini_M).*(ini_THETA-ini_z);

    ##Evolutionary dynamics (Coevolution+Environmental)
    z_result[p_total,2] = ini_z + ini_PHI.*(ini_mut + ini_env);
    #end

####### Assembly Process:
##### Colonization

sp_a = findall(x->x>0, network_full[:,start_pollinators[1]]);
sp_b = findall(x->x>0, network_full[:, start_pollinators[2]]);
sp_ab = setdiff([sp_a;sp_b], start_plants) #possible plants to colonize

sp_c = findall(x->x>0, network_full[start_plants[1],:]);
sp_d = findall(x->x>0, network_full[start_plants[2],:]);
sp_cd =   Splants .+ setdiff([c;d],start_pollinators); # possible pollinators to colonize

sp_colonizer = sample([sp_ab;sp_cd],1)[1]; # choosing one sp from all the possible new colonizers

z_newcolonizer = z_result[sp_colonizer,1]; #grabbing the z of the new colonizer (from mainland)

#to know if it's a plant or a pollinator
if sp_colonizer > Splants
    new_pollinators = sort([start_pollinators; (sp_colonizer - Splants)])
    new_plants = start_plants
else
    new_plants = sort([start_plants; sp_colonizer])
    new_pollinators = start_pollinators
end

colonizer_network = network_full[new_plants,new_pollinators]; #new network in the island (with the new species)

## Square matrix for the new community
new_zero_plant = zeros(size(colonizer_network)[1], size(colonizer_network)[1]);
new_zero_pollinator = zeros(size(colonizer_network)[2], size(colonizer_network)[2]);
new_a = hcat(new_zero_plant, colonizer_network);
new_b = hcat(colonizer_network', new_zero_pollinator);
new_colonizer_network = vcat(new_a,new_b);

####### Coevolutionary dynamic
