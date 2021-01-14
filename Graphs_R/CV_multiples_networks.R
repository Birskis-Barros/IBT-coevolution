###Graph for the CV by coonization/extinction for 9 distinct networks #### 

library("ggpubr") #packadge for combining graphs (e.g., 3x3)

setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/CV/")

data = read.table("complete_2000.csv", sep=",") #carefull, there is no data for network#7 
data = data[-1,]
data = data[,-1]

#use find and replace to change from rede1 to rede10 (stupid way of doing it)
  rede1= data[data$V2 == 1,] #replace the number of the network from 1 to 10 
  rede1$index = (as.numeric(rede1$V3))/0.5
  rede1$index = as.numeric(rede1$index)
  rede1$index = (rede1$index)/10
  
  rede1$V5 = as.numeric(as.character(rede1$V5))
  rede1$CV = rede1$V5/rede1$V4
  rede1$CV[is.na(rede1$CV)] = 0

#generating one plot for each network. Replace g1 to g10 and rede1 to rede10
  g10 <- ggplot(rede10, aes(x=index, y=lCV))+
  geom_point(size=5) + 
  theme_classic() +
  ylab("CV")+
 # ylim(0,0.5)+
  xlab("colozation/extinction rate")+
  theme(axis.text=element_text(size=12), axis.title=element_text(size=18)) 

figure <- ggarrange(g1,g2,g3,g4,g5,g6,g8, g9, g10, #don't forget that there is no rede7 or g7
            labels = c("1", "2", "3", "4", "5", "6", "8", "9", "10"),
            ncol = 3, nrow = 3)
ggsave("log_CV_network1to10(less7).pdf", figure, path="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/gillespie_algorithm/new/cv/", width=20, height = 10)
  