cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

using CSV
using StatsBase
using Distributions

ind_effects = Matrix{Float64}(undef, 145, 9); #row number = number of files in the folder
#col number = relate to the subsets of the network. First colum would be the pool,
#the second column a subset of 80%, 3rd = 60%, 4th=40%, 5th=20%.
col = [0.2:0.1:1;];
col = sort!(col, rev=true);
maxcounter = 500;
def = [1 0; 0 1];
#reps = 20; #number of repetitions
total = Matrix{Float64}[] # how to create a list of matrix and then fill it?

for u=1:length(col)
  *for t in 1:145 # not working
    filename = string("network_",t,".csv");
    network = CSV.read(filename, header=false);
    network = convert(Matrix,network);
    network[network.>1] .= 1 #changing to a 0 and 1 matrix

    ## Picking a subset of the network
    teste = false
    counter = 0
    while teste == false
    new = network;
    newb = Int(round(col[u]*size(new)[1]));
    newc = Int(round(col[u]*size(new)[2]));
    newd = sample(1:size(new)[1], newb, replace = false, ordered = true);
    newe = sample(1:size(new)[2], newc, replace= false, ordered = true);
    network = new[newd,newe];
    network = convert(Matrix,network);
    sums = sum(network);
    nonzerocols = findall(!iszero,vec(sum(network,dims=1)))
    network[:,nonzerocols]
    nonzerorows = findall(!iszero,vec(sum(network,dims=2)))
    network[nonzerorows,:]
    teste = sums != 0
    counter = counter + 1
      if counter > maxcounter
        network = def
        break
        end
    end

    ## Paramenters
    Splants = size(network)[1]; #number of plants
    Spollinator = size(network)[2]; #number of pollinator
    n_S = Splants + Spollinator;
    phi = 0.25; #heritability
    mi = 0.4; #strength of biotic selection
    alfa = 0.2;
    tmax = 100;

    ##Changing labels
  *  rownames(network) <- paste("P", 1:Splants, set="")
  *  colnames(network) <- paste("Pol", 1:Spolinator, set="")

    ##Creating a square matrix
    zero_plant = Matrix{Float64}(undef, Splants, Splants);
    zero_pollinator = Matrix{Float64}(undef, Spollinator, Spollinator);
    a = hcat(zero_plant, network)
  * colnames(a) = [1:1:size(a)[2];]
  * rownames(a) = [1:1:size(a)[1];]
    b = hcat(network', zero_pollinator);
  * colnames(b) = [1:1:size(b)[2];]
  * rownames(b) = [1:1:size(b)[1];]
    network = vcat(a,b);

    ##Creating the matrices
  * M = repeat(mi, 15) #it doesn't work
  * PHI = repeat(phi, 15) #it doesn't work

    ##Enviromental Optima
    THETA = rand(Uniform(0,1), n_S)

    #Initial trait value for each sp
    z_initial = rand(Uniform(0,1), n_S);
    z = z_initial ;

    z_matrix = Matrix{Float64}(undef, tmax, n_S)
    z_matrix[1,:] = z


    

    push!(total, ind_effects) #saving for every reps
  end
end
