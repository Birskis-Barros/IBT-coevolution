cd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

ind_effects = Matrix{Float64}(undef, 145, 9); #row number = number of files in the folder
#col number = relate to the subsets of the network. First colum would be the pool,
#the second colum a subset of 80%, 3rd = 60%, 4th=40%, 5th=20%.

col = [0.2:0.1:1;];
col = sort!(col, rev=true);
maxcounter = 500;
def = [1 0; 0 1];
#reps = 20; #number of repetitions
total = Matrix{Float64}[] # how to create a list of matrix and then fill it?

for u=1:length(col)
  for t in 1:145 # not working
    filename = string("network_",t,".csv");
    network = CSV.read(filename, header=false)
    network = convert(Matrix,network)
    network[network.>1] .= 1 #changing for a 0 and 1 matrix


    push!(total, ind_effects) #saving for every reps
  end
end
