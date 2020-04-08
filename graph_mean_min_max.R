
## Rodar pra cada rede e retirar o min, max e o mean das reps vezes que rodamos. 

for (j in 1:145){ 

  values = matrix(NA, 6, 9) #sendo o numero de linha o total de repeticao 
  medias = matrix(NA,1,9)
  min = matrix(NA,1,9)
  max = matrix(NA,1,9)
  
  #pegando a repeticao de cada rede 
  for (i in 1:length(total)){
   values[i,] =  total[[i]][j,] 
  }
  
  #Tirando o valor min, max, media para cada distancia 
  for (k in 1:9){
  medias[1,k] = mean(values[,k])
  min[1,k] = min(values[,k])
  max[1,k] = max(values[,k])
  } 

medias = as.data.frame(medias)  
min = as.data.frame(min)  
max = as.data.frame(max)

result = cbind(t(medias),t(min))
result = cbind(result, t(max))
result = as.data.frame(result)
colnames(result) = c("mean", "min", "max")
result$distance = c("pool", "90", "80", "70", "60", "50", "40", "30", "20")

ggsave(file=sprintf("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/teste/network_%s.pdf", j),
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

