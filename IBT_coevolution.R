##### Model IBT + Indirect effects of coevolution ###### 

getwd()
setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

ind_effects <- matrix(NA, nrow= 145, ncol=9) #row number = number of files in the folder 
#col number = relate to the subsets of the network. First colum would be the pool, 
#the second colum a subset of 80%, 3rd = 60%, 4th=40%, 5th=20%. 
col = seq(1.0,0.2,-0.1)
maxcounter = 500
def = c(1,0,0,1)
def = matrix(def,2,2)
total = list(NA)

for(r in 1:20){
for (u in 2:length(col)){ 
for (t in 1:145){
  filename <- paste("network_",t,".csv", sep="")
  network = read.csv(filename, header = F)
  network = ifelse(network!=0,1,0) 
  
  ##Including IBT = subset of network
  teste = FALSE
  counter = 0 
  while(teste==FALSE){
  nova = network
  nova.b = round(col[u]*dim(nova)[1])
  nova.c = round(col[u]*dim(nova)[2])
  nova.d = sort(sample(1:dim(nova)[1], nova.b))
  nova.e = sort(sample(1:dim(nova)[2], nova.c))
  network = nova[nova.d,nova.e]
  network <- as.matrix(network)
  sums = sum(network)
  network <- network[ ,which(colSums(network) > 0)] #retirando as colunas sem nenhuma interação
  network <- as.matrix(network)
  network <- network[which(rowSums(network) > 0), ] # retirando as linhas sem nenhuma interação
  network <- as.matrix(network)
  teste = (sums != 0)
  counter = counter + 1
  if (counter > maxcounter) {
    network = def
    break
  }
  }

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
 ind_effects[t,u] = sum(teste)/sum(T) 
 total[[r]] = ind_effects
} 
}
}


