####Trying to incorporate Gillespie Algorithm for the colonization, coevolution, and extinction #####

  global adj_network[adj_network.>1] .= 1; #changing to a 0 and 1 matrix

  global Splants = size(adj_network)[1]; #number of plants
  global Spollinator = size(adj_network)[2]; #number of pollinator
  global n_S = Splants + Spollinator; #total number of species

  ##### The coevolutionary dynamic in the mainland

  mainland = coev_pool(adj_network,phi,alfa,tmax);
  global z_mainland = mainland[1];
  global THETA = mainland[2];

  ###### The Dynamic in the Island

  global z_result = zeros(n_S, tmax); #keeping the traits values of coevolutionary dynamics +
  global z_result[:,1] = z_mainland[tmax,:]; # The first colum is the trait value of species in the mainland +

  # 1) First Colonization

  global start_plants = sample(1:Splants,4, replace=false); # Randomly choosing 4 plant species to first colonize the island

  # 2) First Coevolutionary Process
  first_step = initial_island(tmax, adj_network, z_result, start_plants); #Coevolutionary dynamic of the first 4 species who colonized the island

    global ini_sp_total = copy(first_step[1]); #8 first species to colonize the island +
    global square_colonizer_network = copy(first_step[2]); #new network in the island +
    global island_THETA = copy(first_step[3]); #keep the same theta for the species in the island +
    global z_result[ini_sp_total,2] = copy(first_step[4][ini_sp_total]); #result of the first coevolutinary step in the island +
    global total_island_species = copy(ini_sp_total); #+

    global pollinators = total_island_species[total_island_species .> Splants] .- Splants;
    global plants = total_island_species[total_island_species .<= Splants];

  # 2) Gillespie Dynamic

  N_p = zeros(100);
  N_i = zeros(100);
  d_total = zeros(100);

  while t < t_stop

      N_p[t] = potential_colonizers(adj_network, pollinators, plants, Splants); #number of potential colonizers
      N_i[t] = length(total_island_species); #number of species in the island
      N_total = N_p[t] + N_i[t] + N_i[t]; #total number
      d_total[t] = copy(1/N_total);

      c_event = N_p[t]/N_total; #propability for having colonization
      coev_event = N_i[t]/N_total; #propability for having coevolution
      ext_event = N_i[t]/N_total; #propability for having extinction

      dice = rand();
      pvec = [c_event, coev_event, ext_event];
      cpvec = cumsum(pvec);

     if dice < cpvec[1] ###colonization ###

         finding_column = findall(x->x>0, sum(z_result, dims=1));
         currently_column = length(finding_column)[1];

         global sp_colonizer = colonization(adj_network, pollinators, plants, Splants) # choosing one sp from all the possible new colonizers +

         dice_col = rand(Uniform(0,1)) #### See if its colinize or not (rollind the dices, must be > than col_rate)
         if col_rate < dice_col
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


         global island_species = [new_plants,(Splants.+new_pollinators)]; #+
         z_newcolonizer = z_result[sp_colonizer,1]; #grabbing the z of the new colonizer (from mainland)


         global colonizer_network = zeros(size(adj_network)[1], size(adj_network)[2]); #+
         global colonizer_network[new_plants,new_pollinators] = adj_network[new_plants,new_pollinators]; #new network in the island (with the new species) +

         ## Square matrix for the new community
         new_zero_plant = zeros(size(colonizer_network)[1], size(colonizer_network)[1]);
         new_zero_pollinator = zeros(size(colonizer_network)[2], size(colonizer_network)[2]);
         new_a = hcat(new_zero_plant, colonizer_network);
         new_b = hcat(colonizer_network', new_zero_pollinator);
         global square_colonizer_network = vcat(new_a,new_b);

         global total_island_species = [island_species[1]; island_species[2]];
         global pollinators = total_island_species[total_island_species .> Splants] .- Splants;
         global plants = total_island_species[total_island_species .<= Splants];

         #defining z for the first time step + z of the new colonizer
         if  col_rate < dice_col
             global  z_result[:,currently_column+1] = copy(z_result[:,currently_column]);
         else
             global total_island_species = [island_species[1]; island_species[2]];
             global  z_result[:,currently_column+1] = copy(z_result[:,currently_column]);
             global  z_result[sp_colonizer,currently_column+1] = copy(z_newcolonizer); #here is an "a"!!!!!!!!!!!!!!!
         end

         global pollinators = total_island_species[total_island_species .> Splants] .- Splants;
         global plants = total_island_species[total_island_species .<= Splants];


     elseif cpvec[1]< dice < cpvec[2] # coevolution event

            finding_column = findall(x->x>0, sum(z_result, dims=1));
            currently_column = length(finding_column)[1];

            global total_island_species = [island_species[1]; island_species[2]]; #+

             if total_island_species == []
                 break
             end

             global new_theta = zeros(n_S); #+
             global new_theta[total_island_species] = island_THETA[total_island_species]; #grabbing the theta for the species that are in the island +
             global new_z = copy(z_result[:,currently_column]);

             global new_M = repeat([mi],outer= size(square_colonizer_network)[1]); #+
             global new_PHI = repeat([phi], outer= size(square_colonizer_network)[1]); #+

             new_traits = coev_island(square_colonizer_network, new_z, alfa, new_M, new_PHI, new_theta);
             global z_result[total_island_species,currently_column+1] = new_traits[total_island_species]; #here is an "a"!!!!!!!!!!!!!!! +


     else  cpvec[2]< dice < cpvec[3] # extinction event
         ## First extinction = Due to trait matching or baseline
         finding_column = findall(x->x>0, sum(z_result, dims=1));
         currently_column = length(finding_column)[1];
         trait_mat = (square_colonizer_network.*z_result[:,currently_column])' -  square_colonizer_network.*z_result[:,currently_column]; #here is an "a"!!!!!!!!!!!!!!!
         pri_ext = first_ext(trait_mat, maximumprob, total_island_species, alfa, ext_size) #primary extinction

         ## Defining cascade extinctions
         global total_ext_sp = Array{Array}(undef, 2);

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

         z_result[total_island_species,currently_column+1] = z_result[total_island_species,currently_column]
     end

  t = t + 1

end


##### Coisas ainda para resolver:
# - o que fazer quando o número de especies na ilha for igual ao numero de especies no continente?
