##### Model IBT + Indirect effects of coevolution ###### 

getwd()
setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

ind_effects <- matrix(NA, nrow= 147, ncol=5) #row number = number of files in the folder 
#col number = relate to the subsets of the network. First colum would be the pool, 
#the second colum a subset of 80%, 3rd = 60%, 4th=40%, 5th=20%. 

for (t in 1:147)
  filename <- paste("network_",t,".csv", sep="")
  network = read.csv(filename, header = F)
  network = ifelse(network!=0,1,0) 
  
  ##Including IBT = subset of network
  # nova = network
  # nova.b = round(0.2*dim(nova)[1])
  # nova.c = round(0.2*dim(nova)[2])
  # nova.d = sort(sample(1:dim(nova)[1], nova.b))
  # nova.e = sort(sample(1:dim(nova)[2], nova.c))
  # network = nova[nova.d,nova.e]
  # network <- network[ ,which(colSums(network) > 0)] #nao entendi pq eu tinha feito isso.
  # network <- network[which(rowSums(network) > 0), ]

## Parameters 
Splants = nrow(network) #number of plants
Spolinator = ncol(network) # number of polinators 
n_S = Splants + Spolinator 
phi = 0.25 #heritability
mi = 0.4 #strength of biotic selection 
alfa = 0.2 
tmax = 100

#Changing labels
rownames(network) <- paste("P", 1:Splants, set="")
colnames(network) <- paste("Pol", 1:Spolinator, set="")

##Creating a square matrix 
zero_plant <- matrix(0,Splants,Splants)
zero_polinator <- matrix(0,Spolinator, Spolinator)
a = cbind(zero_plant,network)
colnames(a) = c(1:ncol(a))
rownames(a) = c(1:nrow(a))
b = cbind(t(network), zero_polinator)
colnames(b) = c(1:ncol(b))
rownames(b) = c(1:nrow(b))
network <- rbind(a,b)


##Creating the matrices
M <- rep(mi, n_S)
PHI <- rep(phi, n_S) 

#Environmental Optima
THETA <- runif(n_S, min=0, max=1)

#Initial trait value for each sp
z_initial <- runif(n_S,min=0,max=1) 
z <- z_initial

z_matrix <- matrix(NA, nrow= tmax, ncol=n_S)
z_matrix[1,] <- z

for (i in 1:(tmax-1)){
 z <- z_matrix[i,]
## Calculating trait-matching 
z_dif <- t(network*z) - network*z

##Calculating matrix Q
Q <- network * (exp(-alfa*(z_dif^2)))
Q <- Q/apply(Q,1,sum)

##Multplying by the strength of selection
Q <- Q*M

#Multiplying by the z diff
Q_z <- Q*z_dif
mut <- apply(Q_z,1,sum) #normalizing 

##Calculating the environemntal selection dynamic
env <- (1-M)*(THETA-z)

##Evolutionary dynamics (Coevolution+Environmental)
z_matrix[i+1,] <- z + PHI*(mut + env)

}

##Calculating the indirect effects 
I = diag(1,dim(Q)[1],dim(Q)[2])
A = solve(I-Q)
B = diag(1-mi,dim(Q)[1],dim(Q)[2])  
T= A%*%B

##Indirect effect
 diag(T) = 0
 teste = (1-network)*T
 ind_effects[t,1] = sum(teste)/sum(T) # need to change the colum accordingly to the subset (pool, 80%, 60%, 40%, 20%)
}


