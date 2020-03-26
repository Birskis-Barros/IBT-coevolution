using RCall

R"""
library("ggplot2")
library("reshape2")
ind_effects = as.data.frame($(Array(ind_effects[3,:,:])))
colnames(ind_effects) = c("pool", "ninety", "eighty", "seventy", "sixty", "fifty", "fourty", "thirty", "twenty")
a = melt(ind_effects)
a$network = rep(1:145,9)
a$distance = rep(c("pool", "ninety", "eighty", "seventy", "sixty", "fifty", "fourty", "thirty", "twenty"), each=145)
colnames(a) = c("distance", "value", "network")
ggplot(a, aes(x=factor(distance), y=value, group=factor(network))) +
  geom_line() +
  theme_classic()
"""
