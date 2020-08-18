cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

using CSV
using StatsBase
using Distributions
using LinearAlgebra
using RCall
using DataFrames

include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/coevolution_mainland.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/casc_ext.jl")


m = 8; #chossing network from data folder

phi = 0.25; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter for the trait matching
tmax = 100; #coevolutionary time step

ext_size = 0.2; #baseline extinction rate
col_rate = 0.5; ## defining colonization rate

##network from mainland
filename = string("network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator;

mainland = coev_pool(adj_network,phi,alfa,tmax);

###### The Dynamic in the Island #########

n_time = 100; #number of time steps in the island dynamic

z_result = zeros(n_S, n_time);
z_result[:,1] = mainland[tmax,:]; # The first colum is the trait value of species in the mainland

## Randomly choosing 2 plant species to first colonize the island
start_plants = sample(1:Splants,2, replace=false);

## Randomly choosing 2 pollinators to first colonize the island, one for each plant.
pollinator1 = sample(findall(x->x>0, adj_network[start_plants[1],:]),1);
pollinator2 = sample(findall(x->x>0, adj_network[start_plants[2],:]),1);
start_pollinators = [pollinator1; pollinator2];

## The first network to colonize the island:
first_island_network = zeros(size(adj_network)[1], size(adj_network)[2]); #keeping the same size as pool network because it is easier to track species
first_island_network[start_plants[1],start_pollinators[1]] = 1;
first_island_network[start_plants[2],start_pollinators[2]] = 1;

##Grabbing the trait of those species in the equilibrium (mainland) #as primeiras especies são plantas
p = Splants .+ start_pollinators;
ini_sp_total = [start_plants; p]; #vou usar isso pra preencher o z_result[,:2]
island_z_initial = zeros(n_S);
island_z_initial[ini_sp_total] = z_result[ini_sp_total,1];

## Square matrix for the initial community
ini_zero_plant = zeros(Splants, Splants);
ini_zero_pollinator = zeros(Spollinator, Spollinator);
a = hcat(ini_zero_plant, first_island_network);
b = hcat(first_island_network', ini_zero_pollinator);
square_first_island_network = vcat(a,b);

### Coevolutionary Dynamic for the Island with the initial species

##Enviromental Optima
island_THETA = rand(Uniform(0,1), size(square_first_island_network)[1]); #already choosing theta for all species that can colonize the island

ini_M = repeat([mi],outer= size(square_first_island_network)[1]);
ini_PHI = repeat([phi], outer= size(square_first_island_network)[1]);

#Initial trait value for each sp
ini_z = copy(island_z_initial);

#ini_pool_z_matrix = zeros(tmax, size(square_first_island_network)[1]);
#ini_pool_z_matrix[1,:] = ini_z;

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
    z_result[ini_sp_total,2] = z_final[ini_sp_total];

    square_colonizer_network = copy(square_first_island_network);
    total_island_species = copy(ini_sp_total);
####### Extinctions
    #Essa foi a primeira forma que eu calculei a prob de extincao, mas não funciona.. eu considerei apenas todas as interações possiveis, não olhei pra cada especie.
    # maximumprob = 0.5 #pra chance de extincao da esp com o maior mismatch nao ser 1, multiplicamos por um parametro que limita esse maximum
    # prob_ext = maximumprob.*(vec(exp.(alfa.*(new_z_dif.^2))) ./ maximum(vec(exp.(alfa.*(new_z_dif.^2)))));
    # trait_mat = vec(abs.(new_z_dif));
    # #plot($(Array(prob_ext))~$(Array(trait_mat))) #checking the curve


    for a=9:10
    ## Extinction due to trait matching
    trait_mat = (square_colonizer_network.*z_result[:,a])' -  square_colonizer_network.*z_result[:,a]; #!!!!!!!!!!!!!!!
    abs_new_z_dif = abs.(trait_mat); #all positives
    media_species = zeros(size(abs_new_z_dif)[1]);
    for i=1:size(abs_new_z_dif)[1]
    media_species[i] = mean(abs_new_z_dif[i,findall(!iszero,abs_new_z_dif[i,:])]) #calculating the mean trait matching for each species
    end

    maximumprob = 0.5
    prob_ext = maximumprob.*(vec(exp.(alfa.*(media_species[findall(x->x>0,media_species)].^2))) ./ maximum(vec(exp.(alfa.*(media_species[findall(x->x>0,media_species)].^2))))); #maior a diferenca media de trait matching, maior a chance de ser extinta

    pass_test1 = zeros(size(prob_ext)[1]) .+1;
    roll_dice_1 = rand(Uniform(0,1),size(prob_ext)[1]);
    pass_test1 = pass_test1 .* (roll_dice_1 .< prob_ext); #possible species to get extict due to trait matching

    ## Extinction due to baseline extinction rate related to island size

    pass_test2 = zeros(size(prob_ext)[1]) .+1;
    base_ext = repeat([ext_size], size(prob_ext)[1]);
    roll_dice_2 = rand(Uniform(0,1),size(prob_ext)[1]);
    pass_test2 = pass_test2 .* (roll_dice_2 .< base_ext);

    ## Among all possible species, just one will get extinct
    final_pass_test = pass_test1 .+ pass_test2;
    sp = final_pass_test .> 0;

    if findall(x->x>0,sp) == []
        pri_ext = 0;
    else
        pri_ext = total_island_species[rand(findall(x->x>0,sp), 1)];
    end

    ### Defining cascade extinctions

    total_ext_sp = Array{Array}(undef, 2)

    if pri_ext == 0
        total_ext_sp[1] = [0];
        total_ext_sp[2] = copy(square_colonizer_network);
    else
    total_ext_sp = cascade_ext_sp(square_colonizer_network, pri_ext); #[1] lista de sp extintas em cada time step; [2] matrix com as sp que sobraram (linhas e colunas zeradas das esp extintas)
    end

    sep = zeros(length(total_ext_sp[1]));
    for i=1:length(total_ext_sp[1])
        sep[i] = isassigned(total_ext_sp[1],i)
    end

    total_island_species = setdiff(total_island_species, total_ext_sp[1][last(findall(x->x==1, sep))])

    # if total_island_species == []
    #     break
    # end

    #to know if it's a plant or a pollinator
    pollinators = total_island_species[total_island_species .> Splants] .- Splants;
    plants = total_island_species[total_island_species .< Splants];


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


    #to know if it's a plant or a pollinator
    if sp_colonizer > Splants
        new_pollinators = sort([pollinators; (sp_colonizer - Splants)]);
        new_plants = plants;
    else
        new_plants = sort([plants; sp_colonizer]);
        new_pollinators = pollinators;
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

    new_z = zeros(n_S);
    new_z[total_island_species] = [z_result[setdiff(total_island_species, sp_colonizer),a]; z_newcolonizer]; # !!!!!!!!!!!!!!

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
        z_result[total_island_species,(a+1)] = z_final[total_island_species]; #!!!!!!!!!!!!!! 
    end
