getwd()
setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/results/c_1.0")

listcsv <- dir(pattern = "*.csv")
ldf <- list()
result_10= NA #chage name for each setwd (e.g., c_0.8 = result_08)

for (k in 1:length(listcsv)){
  ldf[[k]] <- read.csv(listcsv[k])
}

for (i in 1:length(listcsv)){
  a = apply(ldf[[i]],2,sum) 
  result_10[i] = length(which(a>0))
}

########

total = matrix(NA, nrow=1000, ncol=2)
total = as.data.frame(total)
total[,1] = rep(seq(0.1,1.0,0.1), each=100)
total[,2] = c(result_01, result_02, result_03, result_04, result_05, result_06, 
              result_07, result_08, result_09, result_10)
colnames(total) = c("ext_rate", "n_timestep")
total$ext_rate = as.character(total$ext_rate)

ggplot(total, aes(x = ext_rate, y=n_timestep, fill=ext_rate)) +
  geom_boxplot() + 
  theme_classic() +
  theme(legend.position="none") + 
  labs(title="Time for community to collapse",x="Colonization Rate", y = "Number of time steps") +
  theme(plot.title = element_text( size = 20, face = "bold")) +
  theme(axis.text.x = element_text(size=16), axis.text.y = element_text(size=16)) +
  theme(axis.title.x = element_text(size=16), axis.title.y = element_text(size=16))

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/timecollapse_colrate1.pdf",
       width = 8, height = 8,
       plot = last_plot())
  
