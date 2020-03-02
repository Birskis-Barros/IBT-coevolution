ind_effects_antplant <- ind_effects
ind_effects_anemonefish <- ind_effects
ind_effects_pollination <- ind_effects
ind_effects_seeddispersal <- ind_effects

result <- matrix(NA,nrow=113,ncol=3)
colnames(result) <- c("indirect","direct","type")
length(ind_effects_anemonefish)+length(ind_effects_antplant)+length(ind_effects_pollination)+length(ind_effects_seeddispersal)


result[1:16,1] <- ind_effects_anemonefish
result[1:16,2] <- 1-(result[1:16,1])
result[1:16,3] <- "anemone-fish"

result[17:20,1] <- ind_effects_antplant
result[17:20,2] <- 1-ind_effects_antplant
result[17:20,3] <- "ant-plant"

result[21:79,1] <- ind_effects_pollination
result[21:79,2] <- 1-ind_effects_pollination
result[21:79,3] <- "pollination"

result[80:113,1] <- ind_effects_seeddispersal
result[80:113,2] <- 1-ind_effects_seeddispersal
result[80:113,3] <- "seed-dispersal"

result$direct <- as.numeric(as.character(result$direct))  
result$indirect <- 1-result$direct

result <- as.data.frame(result)
ggplot(data=result,aes(x=factor(type), y=indirect, fill=type))+
  geom_bar(stat="identity", width=0.7)+
  theme_classic() +
  theme_minimal() 

max(result$indirect[result$type=="anemone-fish"])
max(result$indirect[result$type=="ant-plant"])
max(result$indirect[result$type=="pollination"])
max(result$indirect[result$type=="seed-dispersal"])