####### The dynamic on the mainland ###########

function coev_pool(adj_network, THETA, phi,alfa,events)

    Splants = size(adj_network)[1]; #number of plants
    Spollinator = size(adj_network)[2]; #number of pollinator
    n_S = Splants + Spollinator;

    M = repeat([mi],outer= n_S);
    PHI = repeat([phi], outer= n_S);

    ##Creating a square matrix
    zero_plant = zeros(Splants, Splants);
    zero_pollinator = zeros(Spollinator, Spollinator);
    a = hcat(zero_plant, adj_network);
    b = hcat(adj_network', zero_pollinator);
    square_adj_network = vcat(a,b);

    #Initial trait value for each sp
    z_initial = rand(Uniform(0,1), n_S);
    z = copy(z_initial);

    pool_z_matrix = zeros(events, n_S);
    pool_z_matrix[1,:] = z;

        global Q = Array{Float64}(undef, 0);
        for i = 1:(events-1)
        z = pool_z_matrix[i,:];
        ## Calculating trait-matching
        global z_dif = (square_adj_network.*z)' -  square_adj_network.*z;

        ##Calculating matrix Q
        global Q = square_adj_network .* (exp.(-alfa.*(z_dif.^2)));
        global Q = Q./sum(Q,dims=2);

        ##Multplying by the strength of selection
        global Q = Q.*M;

        ##Multiplying by the z diff
        Q_z = Q .* z_dif;
        mut = vec(sum(Q_z,dims=2)); #normalizing

        ##Calculating the environmental selection dynamic
        env = (1 .-M).*(THETA-z);

        ##Evolutionary dynamics (Coevolution+Environmental)
        pool_z_matrix[i+1,:] = z + PHI.*(mut + env);
        end

    return (
    pool_z_matrix,
    )
end
