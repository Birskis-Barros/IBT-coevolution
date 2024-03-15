setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Data/pollination/")

library("bipartite")

struct = matrix(NA, ncol=6, nrow=54)
struct = as.data.frame(struct)
colnames(struct) = c("Connect", "Links_per_sp", "Richness", "Mod", "NODF", "Densit")

for(i in 3:54){
  filename = paste("network_",i,".csv", sep="")
  net = read.csv(filename, header = T)
  net = as.matrix(net)
  net_str = networklevel(net, weighted=FALSE)
  struct[i,1] = net_str[[1]] #connectance
  struct[i,2] = net_str[[3]] #links per species 
  struct[i,3] = dim(net)[1] + dim(net)[2] #richness
  struct[i,4] = net_str[[7]] #modularity Q 
  struct[i,5] = net_str[[9]] #NODF
  struct[i,6] = net_str[[14]] #linkage density 
  
}

write.csv(struct, file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/network_structure.csv")
