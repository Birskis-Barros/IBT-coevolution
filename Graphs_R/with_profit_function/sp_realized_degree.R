setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/sp_realized_degree/")

#A function to calculate the mean by row excluding zeros values 
mean_excluding_zeros <- function(row) {
  non_zero_values <- row[row != 0]
  if (length(non_zero_values) == 0) {
    return(NA)
  }
  return(mean(non_zero_values))
}

#For each network
net = read.csv("pers_realdegree_nr_net5_1.csv", header=T) #to know the size of rows (line 14)

net_meandegree = matrix(NA, ncol=10, nrow=dim(net)[1])
net_pers = matrix(NA, ncol=10, nrow=dim(net)[1])

## Read replicates 
for (i in 1:10){
    rep = paste("pers_realdegree_nr_net5_", i, ".csv", sep="")
    net_res = read.csv(rep, header=T)
    net_res = net_res[,-1]
    colnames(net_res) =  c("mean_degree", "persistence")
    net_meandegree[,i] = net_res$mean_degree 
    net_pers[,i] = net_res$persistence
}

#Calculating the mean over replicates
net_mean_pers = apply( net_pers, 1, mean_excluding_zeros)
net_mean_degree =  rowMeans(net_meandegree, na.rm = TRUE)

#Combinind mean degree and mean persistence in one dataframe
result = cbind(net_mean_degree, net_mean_pers)
result = as.data.frame(result)
colnames(result) = c("degree", "persistence")

ggplot(result, aes(x=degree, y=persistence)) +
  geom_point() +
  geom_smooth() +
  ylim(0,1) + 
  ylab("Species Persistence") +
  xlab("Mean Realized Degree") +
  ggtitle("Random Extinction") +
  theme_classic()

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/with_profit_function/sp_realized_degree/net5_NR.pdf")
