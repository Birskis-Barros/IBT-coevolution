
for (j in 21:146){
  
  conc = matrix(NA,9,10)
  conc = as.data.frame(conc)  

for (i in 1:length(total)){
  conc[i,] = total[[i]][j,]
}


medias = data.frame(NA)
min = data.frame(NA)
max = data.frame(NA)

for (i in 1:9){
medias[i] = mean(conc[,i])
min[i] = min(conc[,i])
max[i] = max(conc[,i])
}

result = cbind(t(medias),t(min))
result = cbind(result, t(max))
result = as.data.frame(result)
colnames(result) = c("mean", "min", "max")
result$distance = c("pool", "90", "80", "70", "60", "50", "40", "30", "20")

ggsave(file=sprintf("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/mean_indeffects_networks/network_%s.pdf", j),
       width = 6, height = 8,
       plot = last_plot())
       
ggplot(result) + 
  geom_line(aes(factor(distance),mean), group=1) + 
  geom_line(aes(x=factor(distance), y = max, group=1), color = "skyblue") +
  geom_line(aes(x=factor(distance), y = min, group=1), color = "skyblue") + 
  #geom_ribbon(aes(x=factor(distance),ymin=min,ymax=max),color="skyblue", alpha=0.3)+
  scale_x_discrete(limits = c("pool", "90", "80", "70", "60", "50", "40", "30", "20")) +
  xlab("Subset network")  +
  theme_classic()

#dev.off()

}

