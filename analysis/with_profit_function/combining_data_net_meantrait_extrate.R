#### Combining the information of all networks in two dataframes - one for non_random
#extinctions, other for random. 

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/mean_trait_match/")

### For non random ext 
all_net_nr = matrix(NA, ncol=4, nrow=594)
all_net_nr = as.data.frame(all_net_nr)
colnames(all_net_nr) = c("network", "mean_trait_match", "type_ext", "ext_rate")
all_net_nr$type_ext = "non_random"
all_net_nr$network = rep(1:54, each=11)
all_net_nr$ext_rate = rep(seq(0,1, by=0.1), 54)

for (i in 1:dim(all_net_nr)[1]){
    rede = all_net_nr$network[i]
    filename = paste("net_", rede, "_non_random.csv", sep="")
    rede_nr = read.csv(filename, header=T)
    rede_nr$ext_rate = rep(seq(0,1, by=0.1), each=50)
    all_net_nr$mean_trait_match[i]  = mean(rede_nr$values[rede_nr$ext_rate==all_net_nr$ext_rate[i]], na.rm = TRUE)
}  

write.csv(all_net_nr, file="all_net_non_random.csv")


### For random ext 

all_net_r = matrix(NA, ncol=4, nrow=594)
all_net_r = as.data.frame(all_net_r)
colnames(all_net_r) = c("network", "mean_trait_match", "type_ext", "ext_rate")
all_net_r$type_ext = "random"
all_net_r$network = rep(1:54, each=11)
all_net_r$ext_rate = rep(seq(0,1, by=0.1), 54)


for (i in 1:dim(all_net_r)[1]){
  rede = all_net_r$network[i]
  filename = paste("net_", rede, "_random.csv", sep="")
  rede_r = read.csv(filename, header=T)
  rede_r$ext_rate = rep(seq(0,1, by=0.1), each=50)
  all_net_r$mean_trait_match[i]  = mean(rede_r$values[rede_r$ext_rate==all_net_r$ext_rate[i]], na.rm = TRUE)
}  

write.csv(all_net_r, file="all_net_random.csv")

#### Combining inf
#all_net = rbind(all_net_nr, all_net_r)

