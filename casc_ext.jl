function cascade_ext_sp(square_colonizer_network, pri_ext)

#plants + pollinators
n_species = sum(size(square_colonizer_network));

# ##Creating a square matrix
# plant = zeros(size(square_colonizer_network)[1], size(square_colonizer_network)[1]);
# pollinator = zeros(size(square_colonizer_network)[2], size(square_colonizer_network)[2]);
# a = hcat(plant, square_colonizer_network);
# b = hcat(square_colonizer_network', pollinator);
# square_my_network= vcat(a,b);

global ext_species = Array{Array}(undef, n_species)
global ext_species[1] = pri_ext

global ext_matrix = copy(square_colonizer_network);
global ext_matrix[ext_species[1],:] .= 0; #removing all the interactions of ext_species - row
global ext_matrix[:, ext_species[1]] .= 0; #removing all the interactions of ext_species - column

    for i = 2:n_species
        a = mapslices(sum, ext_matrix, dims = 2);
        b = findall(x-> x .==0, a);
        global ext_species[i] = map(i->i[1], b);

        global ext_matrix[ext_species[i],:] .= 0; #removing all the interactions of ext_species - row
        global ext_matrix[:, ext_species[i]] .= 0; #remov

        if ext_species[i] == ext_species[i-1]
           break
       end
   end

return(
ext_species,
 ext_matrix
 )
end