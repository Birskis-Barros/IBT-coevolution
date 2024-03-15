setwd("/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Results/with_profit_function/")

library(reshape2)
library(ggplot2)
library(tidyr)
library(ggpubr)
library(ggside)
library("RColorBrewer")

richness = read.csv("richness_1_5_extrate_06.csv", header=T)
numb_net = 5
events = 5000

richness = richness[,-c(1:2)] #removing the data related to the richness in the mainland
richness = melt(richness)
richness$network = rep(1:numb_net,(events-1))
richness$events = rep(1:(events-1), each=numb_net)
richness$network = as.character(richness$network)

set =  richness[which(richness$network==1:3),]

ggplot(set, aes(x=event, y=value, color=network)) +
  geom_line() +
  ylim(0,1) +
  theme_classic() +
  xlab("Time") +
  ylab("Island relative richness") +
 # scale_color_manual(values = c("1" = "indianred4", 
                              #  "2" = "olivedrab4", 
                               # "3" = "steelblue3")) +
  scale_color_brewer(palette="Dark2") +
  #labs(color="Network") +
  theme(legend.position = "none") +
  theme(axis.text = element_text(size = 16), 
        axis.title = element_text(size = 18),  # Adjust the font size and style for axis titles
        plot.title = element_text(size = 20), 
        legend.title = element_text(size = 14),   # Adjust the size as needed
        legend.text = element_text(size = 12)) 

ggsave(file="/Users/irinabarros/Dropbox/PhD/IBT_Coevolution/Graphs/Paper/island_richness.pdf")
