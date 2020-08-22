#Essa foi a primeira forma que eu calculei a prob de extincao, mas não funciona.. eu considerei apenas todas as interações possiveis, não olhei pra cada especie.
  # maximumprob = 0.5 #pra chance de extincao da esp com o maior mismatch nao ser 1, multiplicamos por um parametro que limita esse maximum
  # prob_ext = maximumprob.*(vec(exp.(alfa.*(new_z_dif.^2))) ./ maximum(vec(exp.(alfa.*(new_z_dif.^2)))));
  # trait_mat = vec(abs.(new_z_dif));
  # #plot($(Array(prob_ext))~$(Array(trait_mat))) #checking the curve

function first_ext(trait_mat, maximumprob, total_island_species, alfa, ext_size)

  abs_new_z_dif = abs.(trait_mat); #all positives
    media_species = zeros(size(abs_new_z_dif)[1]);
        for i=1:size(abs_new_z_dif)[1]
            media_species[i] = mean(abs_new_z_dif[i,findall(!iszero,abs_new_z_dif[i,:])]) #calculating the mean trait matching for each species
        end

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
        global pri_ext = 0;
    else
        global pri_ext = total_island_species[rand(findall(x->x>0,sp), 1)];
    end

    return(
    pri_ext
    )
end 
