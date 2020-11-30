####Incorporating Gillespie Algorithm for the colonization, coevolution, and extinction dynamics#####

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
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/colonization.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/coev_island.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/all_dynamics.jl")
include("$(homedir())/Dropbox/PhD/IBT_Coevolution/Codes/IBT-Coevolution/potential_colonizers.jl")


phi = 0.1; #heritability
mi = 0.4; #strength of biotic selection
alfa = 0.2; #parameter that controls the sensitivity of the evolutionary effect to trait matching
events = 600; #total number of events
ext_size = 0.1; #baseline extinction rate
col_rate = 1.0; ##colonization rate
maximumprob = 0.10; ## maximum probability of extinction based on trait matching


#### Empirical Network
m = 8; #chossing network from data folder (from 1 to 145)
filename = string("network_",m,".csv");
adj_network = CSV.read(filename, header=false);
adj_network = convert(Array,adj_network);
adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

Splants = size(adj_network)[1]; #number of plants
Spollinator = size(adj_network)[2]; #number of pollinator
n_S = Splants + Spollinator; #total number of species

THETA = rand(Uniform(0,1), n_S); #Enviromental Optima Regional Pool

 ##### The coevolutionary dynamic in the mainland

  mainland = coev_pool(adj_network,phi,alfa,events);
  z_mainland = mainland[1];
  z_result = zeros(n_S, events); #keeping the traits values of coevolutionary dynamics +
  z_result[:,1] = z_mainland[events,:]; # The first colum is the trait value of species in the mainland +

  ###### The Dynamic in the Island

  # 1) First Colonization

  start_plants = sample(1:Splants,4, replace=false); # Randomly choosing 4 plant species to first colonize the island

  # 2) First Coevolutionary Process
  first_step = initial_island(adj_network, start_plants, THETA, z_result); #Coevolutionary dynamic of the first 4 species who colonized the island

    ini_sp_total = copy(first_step[1]); #8 first species to colonize the island +
    square_colonizer_network = copy(first_step[2]); #new network in the island +
    #global island_THETA = copy(first_step[3]); #for when we considered different thetas for the mainland and the island
    z_result[ini_sp_total,2] = copy(first_step[3][ini_sp_total]); #result of the first coevolutinary step in the island
    total_island_species = copy(ini_sp_total); #+

    pollinators = total_island_species[total_island_species .> Splants] .- Splants;
    plants = total_island_species[total_island_species .<= Splants];

  # 3) Gillespie Dynamic

  type_event = Array{Union{Nothing, String}}(nothing, events);
  N_p = zeros(events);
  N_i = zeros(events);
  d_total = zeros(events);

 for t=3:(events-1) #because the first 2 columns in z_result is already filled (1st - z in the mainland, 2nd - z of the first 8 species)

      N_p[t] = potential_colonizers(adj_network, plants, pollinators); #number of potential colonizers
      N_i[t] = length(total_island_species); #number of species in the island
      N_total = N_p[t] + N_i[t] + N_i[t]; #total number
      d_total[t] = copy(1/N_total);

      c_event = N_p[t]/N_total; #propability for having colonization
      coev_event = N_i[t]/N_total; #propability for having coevolution
      ext_event = N_i[t]/N_total; #propability for having extinction
      pvec = [c_event, coev_event, ext_event];
      cpvec = cumsum(pvec);
      dice = rand();

     if dice < cpvec[1] ###colonization ###

         finding_column = findall(x->x>0, sum(z_result, dims=1));
         currently_column = length(finding_column)[1];

         type_event[currently_column+1] = "col"

         sp_colonizer = colonization(adj_network, plants, pollinators) # choosing one sp from all the possible new colonizers +

         dice_col = rand(Uniform(0,1)) #### See if its colinize or not (rollind the dices, must be > than col_rate)
         if col_rate < dice_col # it doesn't colonize
             new_plants = plants;
             new_pollinators = pollinators;
         else
             #to know if the new colonizer is a plant or a pollinator
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
         colonizer_network[new_plants,new_pollinators] = adj_network[new_plants,new_pollinators]; #new network in the island (with the new species) +

         ## Square matrix for the new community
         new_zero_plant = zeros(size(colonizer_network)[1], size(colonizer_network)[1]);
         new_zero_pollinator = zeros(size(colonizer_network)[2], size(colonizer_network)[2]);
         new_a = hcat(new_zero_plant, colonizer_network);
         new_b = hcat(colonizer_network', new_zero_pollinator);
         global square_colonizer_network = vcat(new_a,new_b);

         total_island_species = [island_species[1]; island_species[2]];
         pollinators = total_island_species[total_island_species .> Splants] .- Splants; #new pollinators
         plants = total_island_species[total_island_species .<= Splants]; #new plants

         #defining z for the first time step + z of the new colonizer
         if  col_rate < dice_col
            z_result[:,currently_column+1] = copy(z_result[:,currently_column]);
         else
             global total_island_species = [island_species[1]; island_species[2]];
             z_result[:,currently_column+1] = copy(z_result[:,currently_column]);
             z_result[sp_colonizer,currently_column+1] = copy(z_newcolonizer); #here is an "a"!!!!!!!!!!!!!!!
         end

         pollinators = total_island_species[total_island_species .> Splants] .- Splants;
         plants = total_island_species[total_island_species .<= Splants];


     elseif cpvec[1]< dice < cpvec[2] # coevolution event

            finding_column = findall(x->x>0, sum(z_result, dims=1));
            currently_column = length(finding_column)[1];

            type_event[currently_column+1] = "coev"

            new_theta = zeros(n_S); #+
            new_theta[total_island_species] = THETA[total_island_species]; #grabbing the theta for the species that are in the island +
            new_z = copy(z_result[:,currently_column]);

             new_traits = coev_island(square_colonizer_network, new_z, alfa, mi, phi, new_theta);
             z_result[total_island_species,currently_column+1] = new_traits[total_island_species]; #here is an "a"!!!!!!!!!!!!!!! +


     else  cpvec[2]< dice < cpvec[3] # extinction event


         ## First extinction = Due to trait matching or baseline
         finding_column = findall(x->x>0, sum(z_result, dims=1));
         currently_column = length(finding_column)[1];
         trait_mat = (square_colonizer_network.*z_result[:,currently_column])' -  square_colonizer_network.*z_result[:,currently_column]; #here is an "a"!!!!!!!!!!!!!!!
         pri_ext = first_ext(trait_mat, maximumprob, total_island_species, alfa, ext_size); #primary extinction

         type_event[currently_column+1] = "ext"

         ## Defining cascade extinctions
         total_ext_sp = Array{Array}(undef, 2);

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

         global total_island_species = setdiff(total_island_species, total_ext_sp[1][last(findall(x->x==1, sep))]);

         if total_island_species == []
             break
         end

         #to know if it's a plant or a pollinator
         global pollinators = total_island_species[total_island_species .> Splants] .- Splants;
         global plants = total_island_species[total_island_species .<= Splants];

         z_result[total_island_species,currently_column+1] = z_result[total_island_species,currently_column];
     end

end

result = copy(z_result[:,800:1000]);
#d_result = [1:1:200;];
#d_total = cumsum(d_total);
#d_result = hcat(d_result, d_total);

CSV.write("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/results/m144/result30.csv", DataFrame(result))
#CSV.write("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/results/d_result8.csv", DataFrame(d_result))

##### Coisas ainda para resolver:
# - o que fazer quando o número de especies na ilha for igual ao numero de especies no continente?
