cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames

include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/coevolution_mainland.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/casc_ext.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/initial_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/first_ext.jl")

m = 8; #chossing network from data folder

phi = 0.25; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter for the trait matching
tmax = 100; #coevolutionary time step
ext_size = 0.2; #baseline extinction rate
col_rate = 0.8; ## defining colonization rate
maximumprob = 0.5 ## maximum probability of extinction based on trait matching

#### Empirical Network
filename = string("network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator; #total number of species

##### The coevolutionary dynamic in the mainland

mainland = coev_pool(adj_network,phi,alfa,tmax);

###### The Dynamic in the Island

z_result = zeros(n_S, tmax); #keeping the traits values of coevolutionary dynamics
z_result[:,1] = mainland[tmax,:]; # The first colum is the trait value of species in the mainland

# 1) First Colonization

start_plants = sample(1:Splants,2, replace=false); # Randomly choosing 2 plant species to first colonize the island

# 2) First Coevolutionary Process
first_step = initial_island(tmax, adj_network, z_result, start_plants); #Coevolutionary dynamic of the first 4 species who colonized the island

ini_sp_total = copy(first_step[1]); #4 first species to colonize the island
square_colonizer_network = copy(first_step[2]); #new network in the island
island_THETA = copy(first_step[3]); #keep the same theta for the species in the island
z_result[ini_sp_total,2] = copy(first_step[4][ini_sp_total]); #result of the first coevolutinary step in the island
total_island_species = copy(ini_sp_total);

# 3) Extinctions
for a=2:25

    ## First extinction = Due to trait matching or baseline
    trait_mat = (square_colonizer_network.*z_result[:,a])' -  square_colonizer_network.*z_result[:,a]; #here is an "a"!!!!!!!!!!!!!!!
    pri_ext = first_ext(trait_mat, maximumprob, total_island_species, alfa, ext_size) #primary extinction

    ## Defining cascade extinctions
    global total_ext_sp = Array{Array}(undef, 2)

    if pri_ext == 0
        total_ext_sp[1] = [0];
        total_ext_sp[2] = copy(square_colonizer_network);
    else
    global total_ext_sp = cascade_ext_sp(square_colonizer_network, pri_ext); #[1] lista de sp extintas em cada time step; [2] matrix com as sp que sobraram (linhas e colunas zeradas das esp extintas)
    end

    sep = zeros(length(total_ext_sp[1]));
    for i=1:length(total_ext_sp[1])
        sep[i] = isassigned(total_ext_sp[1],i)
    end

    global total_island_species = setdiff(total_island_species, total_ext_sp[1][last(findall(x->x==1, sep))])

    # if total_island_species == []
    #     break
    # end

    #to know if it's a plant or a pollinator
    global pollinators = total_island_species[total_island_species .> Splants] .- Splants;
    global plants = total_island_species[total_island_species .<= Splants];


    ###### COLONIZATION PROCESS ########
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

    sp_colonizer = sample([sp_ab;sp_cd],1)[1]; # choosing one sp from all the possible new colonizers


    dice_col = rand(Uniform(0,1)) #### See if its colinize or not (rollind the dices, must be > than col_rate)
    if dice_col > col_rate
        new_plants = plants;
        new_pollinators = pollinators;
    else
        #to know if it's a plant or a pollinator
        if sp_colonizer > Splants
            new_pollinators = sort([pollinators; (sp_colonizer - Splants)]);
            new_plants = plants;
        else
            new_plants = sort([plants; sp_colonizer]);
            new_pollinators = pollinators;
        end
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
    global square_colonizer_network = vcat(new_a,new_b);

    ####### Coevolutionary dynamic

    total_island_species = [island_species[1]; island_species[2]];
    new_theta = zeros(n_S);
    new_theta[total_island_species] = island_THETA[total_island_species]; #grabbing the theta for the species that are in the island

    new_M = repeat([mi],outer= size(square_colonizer_network)[1]);
    new_PHI = repeat([phi], outer= size(square_colonizer_network)[1]);

    #definir o z do primeito time step + o z da nova especie que colonizou

    new_z = zeros(n_S);
    if  dice_col > col_rate
        new_z[total_island_species] = z_result[total_island_species,a]
    else
        new_z[total_island_species] = [z_result[setdiff(total_island_species, sp_colonizer),a]; z_newcolonizer]; #here is an "a"!!!!!!!!!!!!!!!
    end

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
        z_result[total_island_species,(a+1)] = z_final[total_island_species]; #here is an "a"!!!!!!!!!!!!!!!

        if z_result[total_island_species,(a+1)] == []
            break
        end
    end
