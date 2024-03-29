####Incorporating Gillespie Algorithm for the colonization, coevolution, and extinction dynamics#####

function gillespie_connectance(adj_network, phi, mi, alfa, n_start_plants, ext_size, col_rate, events)


    Splants = size(adj_network)[1]; #number of plants
    Spollinator = size(adj_network)[2]; #number of pollinator
    n_S = Splants + Spollinator; #total number of species

    zero_plant = zeros(Splants, Splants);
    zero_pollinator = zeros(Spollinator, Spollinator);
    a = hcat(zero_plant, adj_network);
    b = hcat(adj_network', zero_pollinator);
    square_adj_network = vcat(a,b); #squar

    connect = zeros(1, events);

     ##### The coevolutionary dynamic in the mainland

      THETA = rand(Uniform(0,1), n_S);
      mainland = coev_pool(adj_network, THETA, phi, mi, alfa,events);
      z_mainland = mainland[1];
      z_result = zeros(n_S, events); #keeping the traits values of coevolutionary dynamics +
      z_result[:,1] = z_mainland[events,:]; # The first colum is the trait value of species in the mainland +

      connect[1,1] = sum(square_adj_network)/length(square_adj_network)

      ###### The Dynamic in the Island

      # 1) First Colonization

      start_plants = sample(1:Splants,n_start_plants, replace=false); # Randomly choosing 4 plant species to first colonize the island

      # 2) First Coevolutionary Process
      first_step = initial_island(adj_network, start_plants, THETA, z_result); #Coevolutionary dynamic of the first 4 species who colonized the island

        ini_sp_total = copy(first_step[1]); #8 first species to colonize the island (order: plants+pollinators)
        square_colonizer_network = copy(first_step[2]); #new network in the island +
        #global island_THETA = copy(first_step[3]); #for when we considered different thetas for the mainland and the island
        z_result[ini_sp_total,2] = copy(first_step[3][ini_sp_total]); #result of the first coevolutinary step in the island
        global total_island_species = copy(ini_sp_total); #+

        connect[1,2] = sum(square_adj_network[total_island_species,total_island_species])/length(square_adj_network[total_island_species,total_island_species])


      # 3) Gillespie Dynamic

      type_event = Array{Union{Nothing, String}}(nothing, events);
      N_p = zeros(events);
      N_i = zeros(events);
      d_total = zeros(events);

     for t=3:(events) #because the first 2 columns in z_result is already filled (1st - z in the mainland, 2nd - z of the first 8 species)

          N_p[t] = potential_colonizers(adj_network, total_island_species); #number of potential colonizers
          N_i[t] = length(total_island_species); #number of species in the island
          N_total = (col_rate*N_p[t]) + (ext_size*N_i[t]) + N_i[t]; #total number
          d_total[t] = copy(1/N_total);

          c_event = (col_rate*N_p[t])/N_total; #propability for having colonization
          coev_event = N_i[t]/N_total; #propability for having coevolution
          ext_event = (ext_size*N_i[t])/N_total; #propability for having extinction
          pvec = [c_event, coev_event, ext_event];
          cpvec = cumsum(pvec);
          dice = rand();

         if dice < cpvec[1] ###colonization ###

             finding_column = findall(x->x>0, sum(z_result, dims=1));
             currently_column = length(finding_column)[1];

             type_event[currently_column+1] = "col"

             sp_colonizer = colonization(adj_network, total_island_species) # choosing one sp from all the possible new colonizers +
             global total_island_species = sort([total_island_species;sp_colonizer])

             z_newcolonizer = z_result[sp_colonizer,1]; #grabbing the z of the new colonizer (from mainland)

             #defining z for the first time step + z of the new colonizer
             z_result[:,currently_column+1] = copy(z_result[:,currently_column]);
             z_result[sp_colonizer,currently_column+1] = copy(z_newcolonizer);

             connect[1,currently_column+1] = sum(square_adj_network[total_island_species,total_island_species])/length(square_adj_network[total_island_species,total_island_species]);



         elseif cpvec[1]< dice < cpvec[2] # coevolution event

                finding_column = findall(x->x>0, sum(z_result, dims=1));
                currently_column = length(finding_column)[1];

                type_event[currently_column+1] = "coev"

                new_theta = zeros(n_S); #+
                new_theta[total_island_species] = THETA[total_island_species]; #grabbing the theta for the species that are in the island +
                new_z = copy(z_result[:,currently_column]);

                new_traits = coev_island(adj_network, total_island_species, new_z, alfa, mi, phi, new_theta);
                z_result[total_island_species,currently_column+1] = new_traits[total_island_species]; #here is an "a"!!!!!!!!!!!!!!! +

                connect[1,currently_column+1] = sum(square_adj_network[total_island_species,total_island_species])/length(square_adj_network[total_island_species,total_island_species]);


         else  cpvec[2]< dice < cpvec[3] # extinction event


             ## First extinction = Due to trait matching or baseline
             finding_column = findall(x->x>0, sum(z_result, dims=1));
             currently_column = length(finding_column)[1];

              type_event[currently_column+1] = "ext"

             trait = copy(z_result[:,currently_column]); #trait of currently species in the island

             pri_ext = first_ext(adj_network, trait, maximumprob, total_island_species, alfa, ext_size); #primary extinction

             ## Defining cascade extinctions
             total_ext_sp = Array{Array}(undef, 2);

             if pri_ext == 0
                 total_ext_sp[1] = [0];
             else
             total_ext_sp = cascade_ext_sp(adj_network, total_island_species, pri_ext); #[1] lista de sp extintas em cada time step; [2] matrix com as sp que sobraram (linhas e colunas zeradas das esp extintas)
             end

             sep = zeros(length(total_ext_sp[1]));
             for i=1:length(total_ext_sp[1])
                 sep[i] = isassigned(total_ext_sp[1],i)
             end

             global total_island_species = setdiff(total_island_species, total_ext_sp[1][last(findall(x->x==1, sep))]);

             if total_island_species == []
                 break
             end

             z_result[total_island_species,currently_column+1] = z_result[total_island_species,currently_column];
             connect[1,currently_column+1] = sum(square_adj_network[total_island_species,total_island_species])/length(square_adj_network[total_island_species,total_island_species]);

         end

     end

return(
z_result,
connect
 )
end
