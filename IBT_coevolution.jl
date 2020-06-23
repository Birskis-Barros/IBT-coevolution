cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

using CSV
using StatsBase
using Distributions
using LinearAlgebra

#ind_effects = Matrix{Float64}(undef, 145, 9); #row number = number of files in the folder
#col number = relate to the subsets of the network. First colum would be the pool,

col = [0.2:0.1:1;];
col = sort!(col, rev=true);
maxcounter = 500;
def = [1 0; 0 1];
reps = 10; #number of repetitions
ind_effects = zeros( reps, 145, length(col)); # how to create a list of matrix and then fill it?

for t=1:145
filename = string("network_",t,".csv");
network_full = CSV.read(filename, header=false);
network_full = convert(Array,network_full);
network_full[network_full.>1] .= 1; #changing to a 0 and 1 matrix
for r=1:reps
for u=1:length(col)

    ## Picking a subset of the network (mantaining the same pronportion betweemn plants and pollinators )
    global network=copy(network_full);
    let counter = 0, teste = false
      while teste == false
        new = copy(network_full);
        newb = Int(round(col[u]*size(new)[1]));
        newc = Int(round(col[u]*size(new)[2]));
        newd = sample(1:size(new)[1], newb, replace = false, ordered = true);
        newe = sample(1:size(new)[2], newc, replace= false, ordered = true);
        global network = new[newd,newe];
        sums = sum(network);
        nonzerocols = findall(!iszero,vec(sum(network,dims=1)));
        global network = network[:,nonzerocols];
        nonzerorows = findall(!iszero,vec(sum(network,dims=2)));
        global network = network[nonzerorows,:];
        teste = sums != 0
        counter = counter + 1
          if counter > maxcounter
            network = copy(def)
            break
          end
      end
    end


    # for u=1:length(col)
    #
    #     ## Picking a subset of the network (choosing the % among all species)
    #     global network=copy(network_full);
    #     let counter = 0, teste = false
    #       while teste == false
    #         new = copy(network_full);
    #         total_species = [1:1:(size(new)[1] + size(new)[2]);];
    #         total_number = Int(round(col[u]*size(total_species)[1]));
    #         newb = sample(1:size(total_species)[1], total_number, replace = false, ordered = true);
    #         newc = findall(x-> x<=size(new)[1],newb);
    #         newd = findall(x-> x>size(new)[1], newb)
    #         newe = newd .-(size(new)[1])
    #         global network = new[newc,newe];
    #         sums = sum(network);
    #         nonzerocols = findall(!iszero,vec(sum(network,dims=1)));
    #         global network = network[:,nonzerocols];
    #         nonzerorows = findall(!iszero,vec(sum(network,dims=2)));
    #         global network = network[nonzerorows,:];
    #         teste = sums != 0
    #         counter = counter + 1
    #           if counter > maxcounter
    #             network = copy(def)
    #             break
    #           end
    #       end
    #     end

    ## Paramenters
    Splants = size(network)[1]; #number of plants
    Spollinator = size(network)[2]; #number of pollinator
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
    a = hcat(zero_plant, network);
    b = hcat(network', zero_pollinator);
    new_network = vcat(a,b);

    ##Enviromental Optima
    THETA = rand(Uniform(0,1), n_S);

    #Initial trait value for each sp
    z_initial = rand(Uniform(0,1), n_S);
    z = z_initial ;

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

    ##Calculating the indirect effects
    I = zeros(Int8,size(Q)[1], size(Q)[2]);
    I[diagind(I)].=1;
    A = inv(I .-Q); #the inverse matrix of (I-Q)
    B = zeros(Float64, size(Q)[1], size(Q)[2]);
    B[diagind(B)].= 1-mi;
    T = A*B;

    ##Indirect effect
    T[diagind(T)].= 0;
    comp = (1 .- new_network) .* T;
    #ind_effects[t,u] = sum(comp)/sum(T);
    ind_effects[r,t,u] = sum(comp)/sum(T);
    end
  end
end

 #ifelse.(isnan.(a), 0, a)
