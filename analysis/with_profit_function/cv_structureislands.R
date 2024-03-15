setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/CV_struc_island/")

library("bipartite")

### Calculate mean CV (richness) of the 10 simulation for each network

#For Non_random ext 
all_net_mean_cv = matrix(NA, ncol=3, nrow=10)
all_net_mean_cv = as.data.frame(all_net_mean_cv)
colnames(all_net_mean_cv) = c("network", "mean_cv", "type_ext")
all_net_mean_cv$network = 1:10
all_net_mean_cv$type_ext = "non_random"

for (i in 1:10){
    filename = paste("net", i, "/Non_random/non_random_05_result_cv.csv", sep="")
    data_cv = read.csv(filename, header=T)
    all_net_mean_cv$mean_cv[i] = mean(data_cv$cv[data_cv$network == i], na.rm = TRUE)
}

#For Random ext 
r_all_net_mean_cv = matrix(NA, ncol=3, nrow=10)
r_all_net_mean_cv = as.data.frame(r_all_net_mean_cv)
colnames(r_all_net_mean_cv) = c("network", "mean_cv", "type_ext")
r_all_net_mean_cv$network = 1:10
all_net_mean_cv$type_ext = "random"

for (i in 1:10){
  filename = paste("net", i, "/Random/random_05_result_cv.csv", sep="")
  data_cv = read.csv(filename, header=T)
  r_all_net_mean_cv$mean_cv[i] = mean(data_cv$cv[data_cv$network == i], na.rm = TRUE)
}

result = rbind(all_net_mean_cv, r_all_net_mean_cv)
write.csv(result, file="all_net_mean_cv.csv")

#### Calculating the mean of network structure on island for the 11 different steps
#and for 10 networks 

#Non_random

  result_NR = matrix(NA, ncol=9, nrow=1100)
  result_NR = as.data.frame(result_NR)
  colnames(result_NR) = c("Network", "Simulation", "Step", "NODF", "Connectance", 
                          "Cluster", "Modularity", "Richness", "Links_per_sp")
  result_NR$Network = rep(seq(1:10), each=110) 
  result_NR$Simulation = rep(seq(1:10), each=11) 
  result_NR$Step = rep(seq(4000,5000, by=100),10)
  
  for (i in 286:dim(result_NR)[1]){
    filename = paste("net", result_NR$Network[i], "/Non_random/", sep="")
    sim = paste(filename, "sim", result_NR$Simulation[i], "/", sep="")
    name_rep = paste("matrix_", result_NR$Step[i], ".csv", sep="")
    file_path = paste(sim, name_rep, sep="")
    
    if (file.size(file_path) > 0) {
        net = read.csv(file_path, as.is= TRUE, header=T)
        net = as.matrix(net)
        
        #structure 
        result_NR$NODF[i] = networklevel(net, index="NODF")
        result_NR$Connectance[i] = networklevel(net, index="connectance")
        result_NR$Cluster[i] = networklevel(net, index="cluster coefficient")[1]
        result_NR$Modularity[i] = networklevel(net, index="modularity")
        result_NR$Richness[i] = sum(networklevel(net, index="number of species"))
        result_NR$Links_per_sp[i] = networklevel(net, index="links per species")
    } else {
      # Print a message or take any other action for empty files
      cat("File is empty. Skipping...\n")
    }
    write.csv(result_NR, file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/CV_struc_island/NR_net_struct.csv")
}
