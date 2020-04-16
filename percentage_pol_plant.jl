using RCall

R"""
library("reshape2")
array = as.data.frame(($(Array(heat_array))))
colnames(array) = c("0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0")
rownames(array) = c("0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0")
result = as.data.frame($(Array(result)))
col = seq(1.0,0.2,-0.1)

### otimizando ## não funcionou, inverteu os resultados
#array$pollinator <- rownames(array)
#result <- melt(array)
#colnames(result) = c("pollinator", "plant", "V3")

###Fazendo na unha
result$pollinator = rep(col, each=9)
result$plant = rep(col,9)
result = result[,c(-1,-2)]

#result[1:9,1] = as.numeric(array[1,])
#result[10:18,1] = as.numeric(array[2,])
#result[19:27,1] = as.numeric(array[3,])
#result[28:36,1] = as.numeric(array[4,])
#result[37:45,1] = as.numeric(array[5,])
#result[46:54,1] = as.numeric(array[6,])
#result[55:63,1] = as.numeric(array[7,])
#result[64:72,1] = as.numeric(array[8,])
#result[73:81,1] = as.numeric(array[9,])


ggplot(result, aes(plant, pollinator, fill= V3)) +
        geom_tile() +
        #scale_fill_gradient(low="white", high="blue") +
        scale_x_continuous(breaks=c(0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)) +
        scale_y_continuous(breaks=c(0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)) +
        labs(x="% plants", y="%pollinators", fill="indirec effect") +
        theme_classic()

"""
