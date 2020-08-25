function coev_island(square_colonizer_network, new_z, alfa, new_M, new_PHI, new_theta)

    global new_Q = Array{Float64}(undef, 0);

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

        return (
            z_final
            )
end
